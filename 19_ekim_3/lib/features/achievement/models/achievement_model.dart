import 'package:flutter/foundation.dart';

@immutable
class AchievementModel {
  final int totalScore;
  final int targetScoreForPet;
  final String? awardedPet;
  final List<String> unlockedBadges;

  const AchievementModel({
    required this.totalScore,
    required this.targetScoreForPet,
    this.awardedPet,
    required this.unlockedBadges,
  });

  factory AchievementModel.initial() {
    return const AchievementModel(
      totalScore: 360,
      targetScoreForPet: 500,
      awardedPet: null,
      unlockedBadges: ['Su Çırağı', 'Haftalık Başlangıç'],
    );
  }

  double get scoreRatio =>
      (totalScore / (targetScoreForPet > 0 ? targetScoreForPet : 1)).clamp(0.0, 1.0);

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
