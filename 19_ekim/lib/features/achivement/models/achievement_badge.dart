// =============================================================================
// achievement_badge.dart - Rozet modeli
// =============================================================================

import 'package:flutter/material.dart';

@immutable
class AchievementBadge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int pointsReward;
  final bool isUnlocked;

  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.pointsReward,
    this.isUnlocked = false,
  });

  // Sadece isUnlocked değişebildiği için copyWith yalnızca onu parametre alır.
  AchievementBadge copyWith({bool? isUnlocked}) {
    return AchievementBadge(
      id: id,
      title: title,
      description: description,
      icon: icon,
      pointsReward: pointsReward,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
