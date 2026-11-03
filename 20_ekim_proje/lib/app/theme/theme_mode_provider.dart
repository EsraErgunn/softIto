// =============================================================================
// theme_mode_provider.dart - Tema modunu (açık/koyu/sistem) yöneten ve cihazda saklayan provider
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/prefs_provider.dart';

const _kThemeModeKey = 'app_theme_mode';

// Notifier: Riverpod'da değiştirilebilir state tutan sınıf. "state" alanına yeni değer
// atanınca bu provider'ı izleyen widget'lar yeniden çizilir.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  // build: provider ilk okunduğunda başlangıç değerini üretir.
  // Kayıtlı tema varsa onu, yoksa sistem temasını döner.
  ThemeMode build() {
    final prefs = ref.watch(prefsProvider);
    final saved = prefs.getString(_kThemeModeKey);
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  // Önce state güncellenir (ekran anında değişir), sonra seçim cihaza kaydedilir;
  // uygulama yeniden açıldığında aynı tema gelir.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(prefsProvider);
    await prefs.setString(_kThemeModeKey, mode.name);
  }
}

// Dışarıdan erişim noktası: ref.watch(themeModeProvider) ile mod,
// ref.read(themeModeProvider.notifier).setThemeMode(...) ile değiştirme.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
