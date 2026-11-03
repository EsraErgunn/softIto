// =============================================================================
// water_tracker_model.dart - Su takibi durumu (immutable)
// =============================================================================

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

  // Hesaplanan değerler: ayrıca saklanmaz, her seferinde mevcut alanlardan hesaplanır.
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

  // JSON (Map) -> nesne. Eksik alanlarda "??" ile varsayılan değer kullanılır.
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
  // Eşitlik operatörü override edildi: iki model nesnesi farklı olsa bile alanları
  // aynıysa "eşit" sayılır. ValueNotifier, yeni değer eskisine == ise dinleyicilere
  // haber VERMEZ; böylece değişmeyen veri için gereksiz yeniden çizim olmaz.
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
  // == override edilince hashCode da aynı alanlardan üretilmelidir (Map/Set'te doğru çalışması için).
  int get hashCode => Object.hash(
        currentWaterMl,
        dailyGoalMl,
        weeklyPoints,
        completedDaysStreak,
        unlockedPetName,
      );
}
