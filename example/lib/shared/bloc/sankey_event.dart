import 'package:equatable/equatable.dart';
import 'package:sankey_diagram_flutter/sankey_diagram_flutter.dart';

sealed class SankeyEvent extends Equatable {
  const SankeyEvent();

  @override
  List<Object?> get props => [];
}

final class SankeyLoadRequested extends SankeyEvent {
  const SankeyLoadRequested();
}

final class SankeyNodeTapped extends SankeyEvent {
  const SankeyNodeTapped(this.node);
  final SankeyNode? node;

  @override
  List<Object?> get props => [node?.id];
}

final class SankeyLinkTapped extends SankeyEvent {
  const SankeyLinkTapped(this.link);
  final SankeyLayoutLink? link;

  @override
  List<Object?> get props => [link?.link.sourceId, link?.link.targetId];
}
