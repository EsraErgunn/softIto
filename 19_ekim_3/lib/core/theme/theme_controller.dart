import 'package:flutter/material.dart';

/// 'project.md' gereği ValueNotifier tabanlı, Light/Dark/System modlarını
/// reaktif yöneten ThemeController sınıfı.
class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  ThemeMode get currentThemeMode => themeModeNotifier.value;

  void setThemeMode(ThemeMode mode) {
    if (themeModeNotifier.value != mode) {
      themeModeNotifier.value = mode;
    }
  }

  void toggleTheme() {
    if (themeModeNotifier.value == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else if (themeModeNotifier.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      // System modundaysa karanlığa geç
      setThemeMode(ThemeMode.dark);
    }
  }
}
