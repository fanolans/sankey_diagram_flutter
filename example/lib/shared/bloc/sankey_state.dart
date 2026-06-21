import 'package:equatable/equatable.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

import '../models/sankey_chart_config.dart';

sealed class SankeyState extends Equatable {
  const SankeyState();

  @override
  List<Object?> get props => [];
}

final class SankeyInitial extends SankeyState {
  const SankeyInitial();
}

final class SankeyLoading extends SankeyState {
  const SankeyLoading();
}

final class SankeyLoaded extends SankeyState {
  const SankeyLoaded({
    required this.config,
    this.selectedNode,
    this.selectedLink,
  });

  final SankeyChartConfig config;
  final SankeyNode? selectedNode;
  final SankeyLayoutLink? selectedLink;

  bool get hasSelection => selectedNode != null || selectedLink != null;

  SankeyLoaded copyWith({
    SankeyChartConfig? config,
    SankeyNode? Function()? selectedNode,
    SankeyLayoutLink? Function()? selectedLink,
  }) {
    return SankeyLoaded(
      config: config ?? this.config,
      selectedNode:
          selectedNode != null ? selectedNode() : this.selectedNode,
      selectedLink:
          selectedLink != null ? selectedLink() : this.selectedLink,
    );
  }

  @override
  List<Object?> get props => [
        config,
        selectedNode?.id,
        selectedLink?.link.sourceId,
        selectedLink?.link.targetId,
      ];
}

final class SankeyError extends SankeyState {
  const SankeyError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
