import 'package:flutter/foundation.dart';

import 'sankey_link.dart';
import 'sankey_node.dart';

@immutable
class SankeyData {
  const SankeyData({
    required this.nodes,
    required this.links,
  });

  final List<SankeyNode> nodes;
  final List<SankeyLink> links;

  SankeyNode? nodeById(String id) {
    for (final n in nodes) {
      if (n.id == id) return n;
    }
    return null;
  }

  List<SankeyLink> outgoingLinks(String nodeId) =>
      links.where((l) => l.sourceId == nodeId).toList();

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
