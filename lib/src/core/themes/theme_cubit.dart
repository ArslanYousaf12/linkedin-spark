import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _preferences;

  ThemeCubit(this._preferences) : super(_loadTheme(_preferences));

  static ThemeMode _loadTheme(SharedPreferences preferences) {
    final String? theme = preferences.getString(_themeKey);
    if (theme == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.name == theme,
      orElse: () => ThemeMode.system,
    );
  }

  void setTheme(ThemeMode theme) {
    emit(theme);
    _preferences.setString(_themeKey, theme.name);
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setTheme(ThemeMode.dark);
    } else {
      setTheme(ThemeMode.light);
    }
  }
}
