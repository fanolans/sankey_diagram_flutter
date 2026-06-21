import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

enum SankeyNodeType { buyer, seller, neutral }

@immutable
class SankeyNode {
  const SankeyNode({
    required this.id,
    required this.label,
    required this.color,
    this.type = SankeyNodeType.neutral,
    this.column,
    this.subLabel,
    this.metadata,
  });

  final String id;
  final String label;
  final Color color;
  final SankeyNodeType type;

  /// Zero-based column index. Overrides [type]-based placement; enables 4+ column layouts.
  /// When null, derived from [type]: buyer→0, neutral→1, seller→rightmost.
  final int? column;

  final String? subLabel;

  // Excluded from == to avoid deep-map comparison.
  final Map<String, dynamic>? metadata;

  SankeyNode copyWith({
    String? id,
    String? label,
    Color? color,
    SankeyNodeType? type,
    int? Function()? column,
    String? subLabel,
    Map<String, dynamic>? metadata,
  }) {
    return SankeyNode(
      id: id ?? this.id,
      label: label ?? this.label,
      color: color ?? this.color,
      type: type ?? this.type,
      column: column != null ? column() : this.column,
      subLabel: subLabel ?? this.subLabel,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SankeyNode &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          color == other.color &&
          type == other.type &&
          column == other.column &&
          subLabel == other.subLabel;

  @override
  int get hashCode => Object.hash(id, label, color, type, column, subLabel);

  @override
  String toString() => 'SankeyNode(id: $id, label: $label, column: ${column ?? type.name})';
}
