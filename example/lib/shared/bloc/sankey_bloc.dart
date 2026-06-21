import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/sankey_repository.dart';
import 'sankey_event.dart';
import 'sankey_state.dart';

class SankeyBloc extends Bloc<SankeyEvent, SankeyState> {
  SankeyBloc(this._repository) : super(const SankeyInitial()) {
    on<SankeyLoadRequested>(_onLoadRequested);
    on<SankeyNodeTapped>(_onNodeTapped);
    on<SankeyLinkTapped>(_onLinkTapped);
  }

  final SankeyRepository _repository;

  Future<void> _onLoadRequested(
    SankeyLoadRequested event,
    Emitter<SankeyState> emit,
  ) async {
    emit(const SankeyLoading());
    try {
      final config = await _repository.loadConfig();
      emit(SankeyLoaded(config: config));
    } catch (e) {
      emit(SankeyError(e.toString()));
    }
  }

  void _onNodeTapped(SankeyNodeTapped event, Emitter<SankeyState> emit) {
    if (state is! SankeyLoaded) return;
    final current = state as SankeyLoaded;
    final isSame = current.selectedNode?.id == event.node?.id;
    emit(current.copyWith(
      selectedNode: () => isSame ? null : event.node,
      selectedLink: () => null,
    ));
  }

  void _onLinkTapped(SankeyLinkTapped event, Emitter<SankeyState> emit) {
    if (state is! SankeyLoaded) return;
    final current = state as SankeyLoaded;
    emit(current.copyWith(
      selectedLink: () => event.link,
      selectedNode: () => null,
    ));
  }
}
