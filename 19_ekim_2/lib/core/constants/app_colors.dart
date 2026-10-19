import 'package:flutter/material.dart';

/// Spor salonu karanlık obsidyen neon ve dinamik açık enerji renk paleti
class AppColors {
  AppColors._();

  // Koyu Tema Arka Planlar (Dark Obsidian & Graphite)
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceElevated = Color(0xFF21262D);
  static const Color surfaceCard = Color(0xFF1B222C);
  static const Color surfaceBorder = Color(0xFF30363D);

  // Aydınlık Tema Arka Planlar (Ferah Açık Spor Paleti)
  static const Color lightBackground = Color(0xFFF6F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFEFF2F5);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightSurfaceBorder = Color(0xFFD0D7DE);

  // Neon & Vurgu Renkleri
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonCyanDim = Color(0xFF0090A8);
  static const Color neonLime = Color(0xFF39FF14);
  static const Color neonLimeDim = Color(0xFF24A10E);
  static const Color neonAmber = Color(0xFFFFB703);
  static const Color neonOrange = Color(0xFFFB8500);
  static const Color neonPurple = Color(0xFFBD00FF);
  static const Color neonPink = Color(0xFFFF007F);

  // Su & Hidrasyon Tonları
  static const Color waterPrimary = Color(0xFF00B4D8);
  static const Color waterSecondary = Color(0xFF0077B6);
  static const Color waterBackground = Color(0xFF0A2239);
  static const Color lightWaterBackground = Color(0xFFE0F7FA);

  // Kalori & Egzersiz Tonları
  static const Color firePrimary = Color(0xFFFF5722);
  static const Color fireSecondary = Color(0xFFFF9800);

  // Koyu Metin Renkleri
  static const Color textPrimary = Color(0xFFF0F6FC);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  static const Color textOnAccent = Color(0xFF0D1117);

  // Aydınlık Metin Renkleri
  static const Color lightTextPrimary = Color(0xFF1F2328);
  static const Color lightTextSecondary = Color(0xFF59636E);
  static const Color lightTextMuted = Color(0xFF8C959F);

  // Durum Renkleri
  static const Color success = Color(0xFF2EA043);
  static const Color warning = Color(0xFFD29922);
  static const Color error = Color(0xFFCF222E);

  // Gradientler
  static const LinearGradient waterGradient = LinearGradient(
    colors: [neonCyan, waterSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient workoutGradient = LinearGradient(
    colors: [firePrimary, fireSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient achievementGradient = LinearGradient(
    colors: [neonPurple, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
