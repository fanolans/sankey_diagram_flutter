import 'package:flutter/painting.dart';

import '../models/sankey_node.dart';

/// Computed layout geometry for a single [SankeyNode].
///
/// [rect] is in canvas coordinates. [value] is the summed flow through the node.
class LayoutNode {
  const LayoutNode({
    required this.node,
    required this.rect,
    required this.value,
    required this.column,
  });

  final SankeyNode node;
  final Rect rect;

  final double value;
  final int column;

  LayoutNode copyWith({
    SankeyNode? node,
    Rect? rect,
    double? value,
    int? column,
  }) {
    return LayoutNode(
      node: node ?? this.node,
      rect: rect ?? this.rect,
      value: value ?? this.value,
      column: column ?? this.column,
    );
  }

  @override
  String toString() =>
      'LayoutNode(id: ${node.id}, rect: $rect, value: $value, col: $column)';
}
