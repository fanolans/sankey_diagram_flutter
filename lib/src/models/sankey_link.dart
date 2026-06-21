import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

@immutable
class SankeyLink {
  const SankeyLink({
    required this.sourceId,
    required this.targetId,
    required this.value,
    this.color,
    this.label,
  });

  final String sourceId;
  final String targetId;

  final double value;
  final Color? color;

  final String? label;

  SankeyLink copyWith({
    String? sourceId,
    String? targetId,
    double? value,
    Color? color,
    String? label,
  }) {
    return SankeyLink(
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      value: value ?? this.value,
      color: color ?? this.color,
      label: label ?? this.label,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SankeyLink &&
          runtimeType == other.runtimeType &&
          sourceId == other.sourceId &&
          targetId == other.targetId &&
          value == other.value;

  @override
  int get hashCode => Object.hash(sourceId, targetId, value);

  @override
  String toString() =>
      'SankeyLink(source: $sourceId → target: $targetId, value: $value)';
}
