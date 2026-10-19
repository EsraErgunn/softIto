import 'package:flutter/foundation.dart';

@immutable
class WaterTrackerModel {
  final int currentWaterMl;
  final int dailyGoalMl;
  final int weeklyPoints;
  final int completedDaysStreak;
  final String? unlockedPetName;

  const WaterTrackerModel({
    required this.currentWaterMl,
    required this.dailyGoalMl,
    required this.weeklyPoints,
    required this.completedDaysStreak,
    this.unlockedPetName,
  });

  factory WaterTrackerModel.initial() {
    return const WaterTrackerModel(
      currentWaterMl: 0,
      dailyGoalMl: 2000,
      weeklyPoints: 240,
      completedDaysStreak: 3,
      unlockedPetName: null,
    );
  }

  bool get isGoalReached => currentWaterMl >= dailyGoalMl;
  double get progressRatio =>
      (currentWaterMl / (dailyGoalMl > 0 ? dailyGoalMl : 1)).clamp(0.0, 1.0);

  WaterTrackerModel copyWith({
    int? currentWaterMl,
    int? dailyGoalMl,
    int? weeklyPoints,
    int? completedDaysStreak,
    String? unlockedPetName,
  }) {
    return WaterTrackerModel(
      currentWaterMl: currentWaterMl ?? this.currentWaterMl,
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      weeklyPoints: weeklyPoints ?? this.weeklyPoints,
      completedDaysStreak: completedDaysStreak ?? this.completedDaysStreak,
      unlockedPetName: unlockedPetName ?? this.unlockedPetName,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      currentWaterMl: json['currentWaterMl'] as int? ?? 0,
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2000,
      weeklyPoints: json['weeklyPoints'] as int? ?? 0,
      completedDaysStreak: json['completedDaysStreak'] as int? ?? 0,
      unlockedPetName: json['unlockedPetName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentWaterMl': currentWaterMl,
      'dailyGoalMl': dailyGoalMl,
      'weeklyPoints': weeklyPoints,
      'completedDaysStreak': completedDaysStreak,
      'unlockedPetName': unlockedPetName,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WaterTrackerModel &&
        other.currentWaterMl == currentWaterMl &&
        other.dailyGoalMl == dailyGoalMl &&
        other.weeklyPoints == weeklyPoints &&
        other.completedDaysStreak == completedDaysStreak &&
        other.unlockedPetName == unlockedPetName;
  }

  @override
  int get hashCode => Object.hash(
        currentWaterMl,
        dailyGoalMl,
        weeklyPoints,
        completedDaysStreak,
        unlockedPetName,
      );
}
