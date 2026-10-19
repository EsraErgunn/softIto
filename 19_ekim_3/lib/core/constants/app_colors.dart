import 'package:flutter/material.dart';

/// 'project.md' dosyasında belirtilen tasarım diline uygun renk paletidir:
/// - Koyu Tema: Gece spor salonu paleti (Dark Obsidian & Neon)
/// - Aydınlık Tema: Açık enerji ve ferah spor paleti
class AppColors {
  AppColors._();

  // Dark Obsidian & Neon Paleti
  static const Color darkBackground = Color(0xFF0F141C);
  static const Color darkSurface = Color(0xFF161F2C);
  static const Color darkSurfaceContainer = Color(0xFF1E2A3B);
  static const Color darkPrimary = Color(0xFF00F2FE); // Neon Cyan
  static const Color darkSecondary = Color(0xFF00FF87); // Neon Mint / Lime
  static const Color darkTertiary = Color(0xFFFF5277); // Neon Coral
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF2E3E55);

  // Açık Enerji & Ferah Spor Paleti
  static const Color lightBackground = Color(0xFFF6F9FD);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFEDF3FC);
  static const Color lightPrimary = Color(0xFF0267F6); // Energetic Blue
  static const Color lightSecondary = Color(0xFF00BA7C); // Fresh Green
  static const Color lightTertiary = Color(0xFFFF6B35); // Energetic Orange
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
}
