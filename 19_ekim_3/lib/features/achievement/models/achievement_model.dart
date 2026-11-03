// =============================================================================
// achievement_model.dart - Başarım durumu (immutable)
// =============================================================================

import 'package:flutter/foundation.dart';

@immutable
class AchievementModel {
  final int totalScore;
  final int targetScoreForPet;
  // Henüz hayvan kazanılmadıysa null.
  final String? awardedPet;
  final List<String> unlockedBadges;

  const AchievementModel({
    required this.totalScore,
    required this.targetScoreForPet,
    this.awardedPet,
    required this.unlockedBadges,
  });

  // Demo başlangıcı: 360 puan, hedef 500, iki açık rozet.
  factory AchievementModel.initial() {
    return const AchievementModel(
      totalScore: 360,
      targetScoreForPet: 500,
      awardedPet: null,
      unlockedBadges: ['Su Çırağı', 'Haftalık Başlangıç'],
    );
  }

  // Hedefe ilerleme oranı; hedef 0 ise sıfıra bölmemek için 1'e bölünür.
  double get scoreRatio =>
      (totalScore / (targetScoreForPet > 0 ? targetScoreForPet : 1)).clamp(0.0, 1.0);

  // NOT: "??" kullanıldığı için copyWith ile bir alan null'a geri çekilemez
  // (awardedPet: null verilirse eski değer korunur). Sıfırlamak için initial() kullanılır.
  AchievementModel copyWith({
    int? totalScore,
    int? targetScoreForPet,
    String? awardedPet,
    List<String>? unlockedBadges,
  }) {
    return AchievementModel(
      totalScore: totalScore ?? this.totalScore,
      targetScoreForPet: targetScoreForPet ?? this.targetScoreForPet,
      awardedPet: awardedPet ?? this.awardedPet,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
    );
  }
}
