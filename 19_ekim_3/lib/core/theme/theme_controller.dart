// =============================================================================
// theme_controller.dart - Tema modunu yöneten SINGLETON sınıf
// Singleton: uygulama boyunca bu sınıftan yalnızca TEK bir nesne vardır
// (ThemeController.instance). Böylece her yerden aynı tema durumuna erişilir.
// =============================================================================

import 'package:flutter/material.dart';

/// 'project.md' gereği ValueNotifier tabanlı, Light/Dark/System modlarını
/// reaktif yöneten ThemeController sınıfı.
class ThemeController {
  // Private constructor: dışarıdan "ThemeController()" ile yeni nesne üretilemez.
  ThemeController._();
  // Tek nesne burada bir kez oluşturulur; her yerde ThemeController.instance kullanılır.
  static final ThemeController instance = ThemeController._();

  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  ThemeMode get currentThemeMode => themeModeNotifier.value;

  void setThemeMode(ThemeMode mode) {
    // Aynı mod tekrar seçilirse gereksiz yeniden çizim yapılmaz.
    if (themeModeNotifier.value != mode) {
      themeModeNotifier.value = mode;
    }
  }

  // Koyu <-> açık arasında geçiş yapar; sistem modundaysa önce koyuya geçer.
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
