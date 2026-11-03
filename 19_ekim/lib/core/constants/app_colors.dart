// =============================================================================
// app_colors.dart - Uygulamanın renk paleti
// Renkler tek bir yerde toplanır; böylece bir rengi değiştirmek için tüm
// widget'ları gezmek gerekmez.
// =============================================================================

import 'package:flutter/material.dart';

/// Dark Obsidian & Neon Gece Spor Salonu Paleti
// "abstract final": bu sınıftan nesne üretilemez ve miras alınamaz;
// sadece AppColors.neonCyan gibi statik sabitlere erişmek için kullanılır.
abstract final class AppColors {
  // Derin Obsidyen Yüzeyler
  static const Color background = Color(0xFF0C0E14);
  static const Color surface = Color(0xFF161922);
  static const Color surfaceElevated = Color(0xFF1E2330);
  static const Color border = Color(0xFF2A3143);

  // Neon Vurgular
  static const Color neonCyan = Color(0xFF00E5FF);
  // Renk kodu 0xAARRGGBB biçimindedir: ilk iki hane (33) saydamlık (~%20 opak).
  // "Glow" renkleri parlama/gölge efektleri için yarı saydamdır.
  static const Color neonCyanGlow = Color(0x3300E5FF);
  static const Color neonLime = Color(0xFF00E676);
  static const Color neonLimeGlow = Color(0x3300E676);
  static const Color neonAmber = Color(0xFFFFAB00);
  static const Color neonCoral = Color(0xFFFF5252);

  // Tipografi Renkleri
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
}
