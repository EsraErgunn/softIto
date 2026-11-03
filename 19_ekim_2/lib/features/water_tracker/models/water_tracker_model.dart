// =============================================================================
// water_tracker_model.dart - Su takibi durumu (immutable)
// =============================================================================

import 'package:flutter/foundation.dart';

@immutable
class WaterTrackerModel {
  final int dailyGoalMl;
  final int consumedMl;
  final DateTime lastUpdated;
  final List<int> intakeHistory;

  const WaterTrackerModel({
    required this.dailyGoalMl,
    required this.consumedMl,
    required this.lastUpdated,
    required this.intakeHistory,
  });

  /// Başlangıç varsayılan değerleri
  // Demo için 1250 ml ile başlar (geçmişte 4 kayıt).
  factory WaterTrackerModel.initial() {
    return WaterTrackerModel(
      dailyGoalMl: 2500,
      consumedMl: 1250,
      lastUpdated: DateTime.now(),
      intakeHistory: const [250, 500, 250, 250],
    );
  }

  // Hedefe ilerleme oranı (0.0 - 1.0). Hedef 0 ise sıfıra bölmemek için 0.0 döner.
  double get progressRatio =>
      dailyGoalMl > 0 ? (consumedMl / dailyGoalMl).clamp(0.0, 1.0) : 0.0;

  // Kalan miktar; hedef aşılınca negatif yerine 0.
  int get remainingMl => (dailyGoalMl - consumedMl).clamp(0, dailyGoalMl);

  int get percentage => (progressRatio * 100).toInt();

  WaterTrackerModel copyWith({
    int? dailyGoalMl,
    int? consumedMl,
    DateTime? lastUpdated,
    List<int>? intakeHistory,
  }) {
    return WaterTrackerModel(
      dailyGoalMl: dailyGoalMl ?? this.dailyGoalMl,
      consumedMl: consumedMl ?? this.consumedMl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      intakeHistory: intakeHistory ?? this.intakeHistory,
    );
  }

  factory WaterTrackerModel.fromJson(Map<String, dynamic> json) {
    return WaterTrackerModel(
      dailyGoalMl: json['dailyGoalMl'] as int? ?? 2500,
      consumedMl: json['consumedMl'] as int? ?? 0,
      lastUpdated: json['lastUpdated'] != null
          // Tarih JSON'da ISO-8601 metin olarak saklanır ("2026-10-19T14:30:00") ve burada geri çevrilir.
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
      intakeHistory: (json['intakeHistory'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyGoalMl': dailyGoalMl,
      'consumedMl': consumedMl,
      // DateTime doğrudan JSON'a yazılamaz; metne çevrilir.
      'lastUpdated': lastUpdated.toIso8601String(),
      'intakeHistory': intakeHistory,
    };
  }
}
