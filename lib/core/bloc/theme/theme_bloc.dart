import 'package:bloc/bloc.dart';
import 'package:cashbook/core/preferences/theme_preferences.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  late MyThemePreferences _preferences;

  ThemeBloc() : super(const ThemeInitial(false)) {
    _preferences = MyThemePreferences();
    on<LoadTheme>((event, emit) async {
      bool isDark = await _preferences.getTheme();
      emit(ThemeInitial(isDark));
    });
    on<ThemeChanged>((event, emit) async {
      bool isDark = await _preferences.getTheme();
      print("THEMEEEEEEEE $isDark");
      await _preferences.setTheme(!isDark);
      emit(AppThemeChanged(!isDark));
    });
  }
}
