import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../models/sankey_data.dart';
import '../models/sankey_link.dart';
import '../models/sankey_node.dart';
import '../models/sankey_style.dart';
import 'layout_link.dart';
import 'layout_node.dart';

/// The result of running [SankeyLayout.compute]: positioned nodes and links.
class SankeyLayoutResult {
  const SankeyLayoutResult({
    required this.nodes,
    required this.links,
    required this.numColumns,
  });

  /// Node geometries keyed by [SankeyNode.id].
  final Map<String, LayoutNode> nodes;

  /// Ordered list of ribbon geometries, one per [SankeyLink].
  final List<LayoutLink> links;

  /// Total number of columns in this layout.
  final int numColumns;
}

/// Stateless layout engine that converts [SankeyData] into pixel geometry.
///
/// When [SankeyStyle.autoLayout] is `true`, column positions are derived from
/// link topology via BFS (longest-path) and vertical positions are refined
/// with iterative relaxation — matching d3-sankey behaviour.
/// When `false`, columns come from [SankeyNode.column] / [SankeyNode.type].
class SankeyLayout {
  const SankeyLayout._();

  /// Computes node and link positions for the given [data] and canvas [size].
  static SankeyLayoutResult compute({
    required SankeyData data,
    required Size size,
    required SankeyStyle style,
  }) {
    if (data.nodes.isEmpty) {
      return const SankeyLayoutResult(nodes: {}, links: [], numColumns: 0);
    }

    final columnMap = style.autoLayout
        ? _assignColumnsAuto(data, style.nodeAlignment)
        : _assignColumnsManual(data);

    final numColumns = columnMap.values.isEmpty
        ? 1
        : columnMap.values.reduce(math.max) + 1;

    final columnNodes = <int, List<SankeyNode>>{};
    for (final node in data.nodes) {
      final col = columnMap[node.id] ?? 0;
      columnNodes.putIfAbsent(col, () => []).add(node);
    }

    final nodeValues = _computeNodeValues(data);

    for (final nodes in columnNodes.values) {
      switch (style.sortOrder) {
        case SortOrder.byValue:
          nodes.sort(
            (a, b) => (nodeValues[b.id] ?? 0).compareTo(nodeValues[a.id] ?? 0),
          );
        case SortOrder.byLabel:
          nodes.sort((a, b) => a.label.compareTo(b.label));
        case SortOrder.none:
          break;
      }
    }

    final scale = _computeScale(
      columnNodes: columnNodes,
      nodeValues: nodeValues,
      canvasHeight: size.height,
      style: style,
    );

    final columnX = _computeColumnX(
      numColumns: numColumns,
      canvasWidth: size.width,
      style: style,
    );

    final layoutNodes = <String, LayoutNode>{};
    final columnNodeIds = <int, List<String>>{};

    for (final entry in columnNodes.entries) {
      final col = entry.key;
      final nodes = entry.value;
      final x = columnX[col] ?? 0.0;

      final totalNodeH =
          nodes.fold(0.0, (s, n) => s + (nodeValues[n.id] ?? 0) * scale);
      final totalH = totalNodeH + (nodes.length - 1) * style.nodePadding;

      var y = style.verticalPadding +
          (size.height - totalH - style.verticalPadding * 2) / 2;
      y = y.clamp(style.verticalPadding, double.infinity);

      final ids = <String>[];
      for (final node in nodes) {
        final nodeH = math.max((nodeValues[node.id] ?? 0) * scale, 1.0);
        layoutNodes[node.id] = LayoutNode(
          node: node,
          rect: Rect.fromLTWH(x, y, style.nodeWidth, nodeH),
          value: nodeValues[node.id] ?? 0,
          column: col,
        );
        y += nodeH + style.nodePadding;
        ids.add(node.id);
      }
      columnNodeIds[col] = ids;
    }

    if (style.autoLayout && style.layoutIterations > 0) {
      _relaxNodes(
        layoutNodes: layoutNodes,
        columnNodeIds: columnNodeIds,
        data: data,
        canvasHeight: size.height,
        style: style,
        iterations: style.layoutIterations,
      );
    }

    final layoutLinks = _computeLinks(
      data: data,
      layoutNodes: layoutNodes,
      scale: scale,
    );

    return SankeyLayoutResult(
      nodes: layoutNodes,
      links: layoutLinks,
      numColumns: numColumns,
    );
  }

  static Map<String, int> _assignColumnsManual(SankeyData data) {
    final hasExplicit = data.nodes.any((n) => n.column != null);
    if (hasExplicit) {
      return {for (final n in data.nodes) n.id: n.column ?? 0};
    }

    final hasNeutral = data.nodes.any((n) => n.type == SankeyNodeType.neutral);
    final result = <String, int>{};
    for (final node in data.nodes) {
      result[node.id] = switch (node.type) {
        SankeyNodeType.buyer => 0,
        SankeyNodeType.neutral => 1,
        SankeyNodeType.seller => hasNeutral ? 2 : 1,
      };
    }
    return result;
  }

  /// Derives column indices from link topology using BFS (longest-path depth).
  static Map<String, int> _assignColumnsAuto(
      SankeyData data, NodeAlignment alignment) {
    final outgoing = <String, List<String>>{};
    final incoming = <String, List<String>>{};

    for (final node in data.nodes) {
      outgoing[node.id] = [];
      incoming[node.id] = [];
    }
    for (final link in data.links) {
      outgoing[link.sourceId]?.add(link.targetId);
      incoming[link.targetId]?.add(link.sourceId);
    }

    final columns = <String, int>{};
    final queue = <String>[];

    for (final node in data.nodes) {
      if ((incoming[node.id] ?? []).isEmpty) {
        columns[node.id] = 0;
        queue.add(node.id);
      }
    }
    // Fully cyclic graph — seed everything at column 0
    if (queue.isEmpty) {
      for (final node in data.nodes) {
        columns[node.id] = 0;
        queue.add(node.id);
      }
    }

    // BFS: longest-path depth so each node gets its rightmost valid column
    var head = 0;
    while (head < queue.length) {
      final id = queue[head++];
      final col = columns[id] ?? 0;
      for (final targetId in outgoing[id] ?? []) {
        final candidate = col + 1;
        if (!columns.containsKey(targetId) ||
            columns[targetId]! < candidate) {
          columns[targetId] = candidate;
          queue.add(targetId);
        }
      }
    }

    for (final node in data.nodes) {
      columns.putIfAbsent(node.id, () => 0);
    }

    final maxCol =
        columns.values.isEmpty ? 0 : columns.values.reduce(math.max);

    if (alignment == NodeAlignment.justify ||
        alignment == NodeAlignment.right) {
      for (final node in data.nodes) {
        if ((outgoing[node.id] ?? []).isEmpty) {
          columns[node.id] = maxCol;
        }
      }
    }

    if (alignment == NodeAlignment.center) {
      final reverseDepth = <String, int>{};
      final rQueue = <String>[];
      for (final node in data.nodes) {
        if ((outgoing[node.id] ?? []).isEmpty) {
          reverseDepth[node.id] = 0;
          rQueue.add(node.id);
        }
      }
      var rHead = 0;
      while (rHead < rQueue.length) {
        final id = rQueue[rHead++];
        final d = reverseDepth[id] ?? 0;
        for (final srcId in incoming[id] ?? []) {
          final candidate = d + 1;
          if (!reverseDepth.containsKey(srcId) ||
              reverseDepth[srcId]! < candidate) {
            reverseDepth[srcId] = candidate;
            rQueue.add(srcId);
          }
        }
      }
      for (final node in data.nodes) {
        final fwd = columns[node.id] ?? 0;
        final rev = reverseDepth[node.id];
        if (rev != null) {
          final centered = ((fwd + (maxCol - rev)) / 2).round();
          columns[node.id] = centered.clamp(0, maxCol);
        }
      }
    }

    return columns;
  }

  static void _relaxNodes({
    required Map<String, LayoutNode> layoutNodes,
    required Map<int, List<String>> columnNodeIds,
    required SankeyData data,
    required double canvasHeight,
    required SankeyStyle style,
    required int iterations,
  }) {
    for (var i = 0; i < iterations; i++) {
      // Decreasing alpha ensures the layout converges rather than oscillates
      final alpha = 1.0 - (i + 1) / (iterations + 1);
      _relaxFromSource(layoutNodes, data, alpha);
      _resolveCollisions(layoutNodes, columnNodeIds, canvasHeight, style);
      _relaxFromTarget(layoutNodes, data, alpha);
      _resolveCollisions(layoutNodes, columnNodeIds, canvasHeight, style);
    }
  }

  /// Pull each node toward the weighted centre of its incoming links' sources.
  static void _relaxFromSource(
    Map<String, LayoutNode> layoutNodes,
    SankeyData data,
    double alpha,
  ) {
    final byTarget = <String, List<SankeyLink>>{};
    for (final link in data.links) {
      final src = layoutNodes[link.sourceId];
      final tgt = layoutNodes[link.targetId];
      if (src != null && tgt != null && src.column < tgt.column) {
        byTarget.putIfAbsent(link.targetId, () => []).add(link);
      }
    }
    for (final entry in byTarget.entries) {
      final node = layoutNodes[entry.key]!;
      double wSum = 0, wTot = 0;
      for (final lk in entry.value) {
        wSum += layoutNodes[lk.sourceId]!.rect.center.dy * lk.value;
        wTot += lk.value;
      }
      if (wTot > 0) {
        final delta = (wSum / wTot - node.rect.center.dy) * alpha;
        layoutNodes[entry.key] =
            node.copyWith(rect: node.rect.translate(0, delta));
      }
    }
  }

  /// Pull each node toward the weighted centre of its outgoing links' targets.
  static void _relaxFromTarget(
    Map<String, LayoutNode> layoutNodes,
    SankeyData data,
    double alpha,
  ) {
    final bySource = <String, List<SankeyLink>>{};
    for (final link in data.links) {
      final src = layoutNodes[link.sourceId];
      final tgt = layoutNodes[link.targetId];
      if (src != null && tgt != null && src.column < tgt.column) {
        bySource.putIfAbsent(link.sourceId, () => []).add(link);
      }
    }
    for (final entry in bySource.entries) {
      final node = layoutNodes[entry.key]!;
      double wSum = 0, wTot = 0;
      for (final lk in entry.value) {
        wSum += layoutNodes[lk.targetId]!.rect.center.dy * lk.value;
        wTot += lk.value;
      }
      if (wTot > 0) {
        final delta = (wSum / wTot - node.rect.center.dy) * alpha;
        layoutNodes[entry.key] =
            node.copyWith(rect: node.rect.translate(0, delta));
      }
    }
  }

  /// Push overlapping nodes apart and clamp them inside the canvas.
  static void _resolveCollisions(
    Map<String, LayoutNode> layoutNodes,
    Map<int, List<String>> columnNodeIds,
    double canvasHeight,
    SankeyStyle style,
  ) {
    for (final ids in columnNodeIds.values) {
      final sorted = List<String>.from(ids)
        ..sort((a, b) =>
            layoutNodes[a]!.rect.top.compareTo(layoutNodes[b]!.rect.top));

      // Push down
      var y = style.verticalPadding;
      for (final id in sorted) {
        final n = layoutNodes[id]!;
        if (n.rect.top < y) {
          layoutNodes[id] =
              n.copyWith(rect: Rect.fromLTWH(n.rect.left, y, n.rect.width, n.rect.height));
        }
        y = layoutNodes[id]!.rect.bottom + style.nodePadding;
      }

      // Push up
      y = canvasHeight - style.verticalPadding;
      for (final id in sorted.reversed) {
        final n = layoutNodes[id]!;
        if (n.rect.bottom > y) {
          layoutNodes[id] = n.copyWith(
            rect: Rect.fromLTWH(
                n.rect.left, y - n.rect.height, n.rect.width, n.rect.height),
          );
        }
        y = layoutNodes[id]!.rect.top - style.nodePadding;
      }
    }
  }

  static Map<String, double> _computeNodeValues(SankeyData data) {
    final outflow = <String, double>{};
    final inflow = <String, double>{};

    for (final link in data.links) {
      outflow[link.sourceId] = (outflow[link.sourceId] ?? 0) + link.value;
      inflow[link.targetId] = (inflow[link.targetId] ?? 0) + link.value;
    }

    final result = <String, double>{};
    for (final node in data.nodes) {
      result[node.id] = (outflow[node.id] ?? 0) > 0
          ? outflow[node.id]!
          : (inflow[node.id] ?? 0);
    }
    return result;
  }

  static double _computeScale({
    required Map<int, List<SankeyNode>> columnNodes,
    required Map<String, double> nodeValues,
    required double canvasHeight,
    required SankeyStyle style,
  }) {
    var scale = double.infinity;
    for (final nodes in columnNodes.values) {
      if (nodes.isEmpty) continue;
      final available = canvasHeight -
          style.verticalPadding * 2 -
          (nodes.length - 1) * style.nodePadding;
      if (available <= 0) continue;
      final colTotal =
          nodes.fold(0.0, (s, n) => s + (nodeValues[n.id] ?? 0));
      if (colTotal > 0) scale = math.min(scale, available / colTotal);
    }
    return scale.isInfinite ? 1.0 : scale;
  }

  static Map<int, double> _computeColumnX({
    required int numColumns,
    required double canvasWidth,
    required SankeyStyle style,
  }) {
    final nodeWidth = style.nodeWidth;
    final hPad = style.horizontalPadding;
    final usable = canvasWidth - hPad * 2;

    if (numColumns == 1) {
      return {0: hPad + (usable - nodeWidth) / 2};
    }

    final result = <int, double>{};
    for (var col = 0; col < numColumns; col++) {
      if (col == 0) {
        result[col] = hPad;
      } else if (col == numColumns - 1) {
        result[col] = hPad + usable - nodeWidth;
      } else {
        result[col] =
            hPad + col / (numColumns - 1) * (usable - nodeWidth);
      }
    }
    return result;
  }

  static List<LayoutLink> _computeLinks({
    required SankeyData data,
    required Map<String, LayoutNode> layoutNodes,
    required double scale,
  }) {
    final srcOffset = <String, double>{};
    final tgtOffset = <String, double>{};
    final result = <LayoutLink>[];

    for (final link in data.links) {
      final srcNode = layoutNodes[link.sourceId];
      final tgtNode = layoutNodes[link.targetId];
      if (srcNode == null || tgtNode == null) continue;

      final thickness = link.value * scale;
      final srcY = srcNode.rect.top + (srcOffset[link.sourceId] ?? 0);
      final tgtY = tgtNode.rect.top + (tgtOffset[link.targetId] ?? 0);

      result.add(LayoutLink(
        link: link,
        sourceNode: srcNode,
        targetNode: tgtNode,
        sourceY: srcY,
        targetY: tgtY,
        thickness: thickness,
        isCircular: srcNode.column >= tgtNode.column,
      ));

      srcOffset[link.sourceId] = (srcOffset[link.sourceId] ?? 0) + thickness;
      tgtOffset[link.targetId] = (tgtOffset[link.targetId] ?? 0) + thickness;
    }

    return result;
  }
}
