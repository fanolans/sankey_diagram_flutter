import 'dart:math' show min;

import 'package:flutter/painting.dart';

import '../models/sankey_data.dart';
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

    final columnMap = _assignColumns(data);
    final numColumns = columnMap.values.toSet().length;

    final columnNodes = <int, List<SankeyNode>>{};
    for (final node in data.nodes) {
      final col = columnMap[node.id] ?? 0;
      columnNodes.putIfAbsent(col, () => []).add(node);
    }

    final nodeValues = _computeNodeValues(data);

    for (final col in columnNodes.keys) {
      final nodes = columnNodes[col]!;
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
      nodeWidth: style.nodeWidth,
    );

    final layoutNodes = <String, LayoutNode>{};

    for (final entry in columnNodes.entries) {
      final col = entry.key;
      final nodes = entry.value;
      final x = columnX[col] ?? 0.0;

      final totalNodeH =
          nodes.fold(0.0, (s, n) => s + (nodeValues[n.id] ?? 0) * scale);
      final totalH = totalNodeH + (nodes.length - 1) * style.nodePadding;

      var currentY = style.verticalPadding +
          (size.height - totalH - style.verticalPadding * 2) / 2;
      currentY = currentY.clamp(style.verticalPadding, double.infinity);

      for (final node in nodes) {
        final nodeH = (nodeValues[node.id] ?? 0) * scale;
        layoutNodes[node.id] = LayoutNode(
          node: node,
          rect: Rect.fromLTWH(x, currentY, style.nodeWidth, nodeH),
          value: nodeValues[node.id] ?? 0,
          column: col,
        );
        currentY += nodeH + style.nodePadding;
      }
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

  static Map<String, int> _assignColumns(SankeyData data) {
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

    for (final entry in columnNodes.entries) {
      final nodes = entry.value;
      if (nodes.isEmpty) continue;

      final available = canvasHeight -
          style.verticalPadding * 2 -
          (nodes.length - 1) * style.nodePadding;

      if (available <= 0) continue;

      final colTotal = nodes.fold(0.0, (s, n) => s + (nodeValues[n.id] ?? 0));
      if (colTotal > 0) scale = min(scale, available / colTotal);
    }

    return scale.isInfinite ? 1.0 : scale;
  }

  static Map<int, double> _computeColumnX({
    required int numColumns,
    required double canvasWidth,
    required double nodeWidth,
  }) {
    if (numColumns == 1) return {0: (canvasWidth - nodeWidth) / 2};

    final result = <int, double>{};
    for (var col = 0; col < numColumns; col++) {
      if (col == 0) {
        result[col] = 0;
      } else if (col == numColumns - 1) {
        result[col] = canvasWidth - nodeWidth;
      } else {
        result[col] = col / (numColumns - 1) * (canvasWidth - nodeWidth);
      }
    }
    return result;
  }

  static List<LayoutLink> _computeLinks({
    required SankeyData data,
    required Map<String, LayoutNode> layoutNodes,
    required double scale,
  }) {
    final sourceOffset = <String, double>{};
    final targetOffset = <String, double>{};
    final result = <LayoutLink>[];

    for (final link in data.links) {
      final srcNode = layoutNodes[link.sourceId];
      final tgtNode = layoutNodes[link.targetId];
      if (srcNode == null || tgtNode == null) continue;

      final thickness = link.value * scale;
      final srcY = srcNode.rect.top + (sourceOffset[link.sourceId] ?? 0);
      final tgtY = tgtNode.rect.top + (targetOffset[link.targetId] ?? 0);

      result.add(LayoutLink(
        link: link,
        sourceNode: srcNode,
        targetNode: tgtNode,
        sourceY: srcY,
        targetY: tgtY,
        thickness: thickness,
      ));

      sourceOffset[link.sourceId] =
          (sourceOffset[link.sourceId] ?? 0) + thickness;
      targetOffset[link.targetId] =
          (targetOffset[link.targetId] ?? 0) + thickness;
    }

    return result;
  }
}
