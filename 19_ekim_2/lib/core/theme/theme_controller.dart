// =============================================================================
// theme_controller.dart - Tema modunu (sistem / koyu / açık) yöneten sınıf
// ValueNotifier tek bir değeri tutar; değer değişince onu dinleyen
// ValueListenableBuilder'lar otomatik yeniden çizilir.
// =============================================================================

import 'package:flutter/material.dart';

/// Sistem aydınlık ve karanlık modlarını ValueNotifier ile yöneten reaktif kontrolcü
class ThemeController {
  final ValueNotifier<ThemeMode> themeModeNotifier =
      // Uygulama ilk açıldığında telefonun sistem temasına uyulur.
      ValueNotifier<ThemeMode>(ThemeMode.system);

  ThemeMode get currentMode => themeModeNotifier.value;

  /// Belirli bir tema moduna geçer (Sistem, Koyu, Açık)
  void setThemeMode(ThemeMode mode) {
    // .value'ya yeni değer atamak dinleyicilere otomatik haber verir (notifyListeners gerekmez).
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

  // Notifier'ın dinleyici listesini temizler; uygulama kapanırken çağrılır.
  void dispose() {
    themeModeNotifier.dispose();
  }
}
