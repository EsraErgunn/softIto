import 'package:flutter/material.dart';

/// Sistem aydınlık ve karanlık modlarını ValueNotifier ile yöneten reaktif kontrolcü
class ThemeController {
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  ThemeMode get currentMode => themeModeNotifier.value;

  /// Belirli bir tema moduna geçer (Sistem, Koyu, Açık)
  void setThemeMode(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }

  /// Temayı döngüsel olarak değiştirir: Sistem -> Koyu -> Açık -> Sistem
  void toggleTheme() {
    switch (themeModeNotifier.value) {
      case ThemeMode.system:
        themeModeNotifier.value = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        themeModeNotifier.value = ThemeMode.light;
        break;
      case ThemeMode.light:
        themeModeNotifier.value = ThemeMode.system;
        break;
    }
  }

  void dispose() {
    themeModeNotifier.dispose();
  }
}
