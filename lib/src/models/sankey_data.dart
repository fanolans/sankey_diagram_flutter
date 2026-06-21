import 'package:flutter/foundation.dart';

import 'sankey_link.dart';
import 'sankey_node.dart';

/// The complete data model for a Sankey diagram: a set of [nodes] and [links].
///
/// Pass this to [SankeyDiagram.data]. The class is immutable — call
/// [copyWith] to produce an updated instance when data changes.
@immutable
class SankeyData {
  const SankeyData({
    required this.nodes,
    required this.links,
  });

  final List<SankeyNode> nodes;
  final List<SankeyLink> links;

  /// Returns the [SankeyNode] with the given [id], or `null` if not found.
  SankeyNode? nodeById(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  /// Returns all links whose [SankeyLink.sourceId] matches [nodeId].
  List<SankeyLink> outgoingLinks(String nodeId) =>
      links.where((l) => l.sourceId == nodeId).toList();

  /// Returns all links whose [SankeyLink.targetId] matches [nodeId].
  List<SankeyLink> incomingLinks(String nodeId) =>
      links.where((l) => l.targetId == nodeId).toList();

  SankeyData copyWith({
    List<SankeyNode>? nodes,
    List<SankeyLink>? links,
  }) {
    return SankeyData(
      nodes: nodes ?? this.nodes,
      links: links ?? this.links,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SankeyData &&
          runtimeType == other.runtimeType &&
          _listEquals(nodes, other.nodes) &&
          _listEquals(links, other.links);

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll([...nodes, ...links]);

  @override
  String toString() =>
      'SankeyData(nodes: ${nodes.length}, links: ${links.length})';
}
