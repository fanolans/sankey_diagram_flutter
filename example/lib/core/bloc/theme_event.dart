import 'package:equatable/equatable.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

final class ThemeToggleRequested extends ThemeEvent {
  const ThemeToggleRequested();
}
