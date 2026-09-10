import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and provides the current ThemeMode (dark / light)
final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    _loadSavedTheme();
  }

  static const _key = 'app_theme_mode';

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key) ?? 'dark';
    state = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> toggle() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, state == ThemeMode.light ? 'light' : 'dark');
  }

  bool get isDark => state == ThemeMode.dark;
}

extension ThemeModeX on ThemeMode {
  bool get isDark => this == ThemeMode.dark;
}
