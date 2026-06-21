import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(ThemeMode.dark)) {
    on<ThemeToggleRequested>((event, emit) {
      emit(ThemeState(state.isDark ? ThemeMode.light : ThemeMode.dark));
    });
  }
}
