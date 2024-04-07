part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {
  final bool isDark;

  const ThemeState(this.isDark);
}

final class ThemeInitial extends ThemeState {
  const ThemeInitial(super.isDark);
}

final class AppThemeChanged extends ThemeState {
  const AppThemeChanged(super.isDark);
}
