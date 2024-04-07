part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

class ThemeChanged extends ThemeEvent {}

class LoadTheme extends ThemeEvent {}
