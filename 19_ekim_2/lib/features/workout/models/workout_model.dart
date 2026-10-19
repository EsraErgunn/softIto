import 'package:flutter/foundation.dart';

@immutable
class WorkoutItem {
  final String id;
  final String title;
  final String category;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;

  const WorkoutItem({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
  });

  WorkoutItem copyWith({
    String? id,
    String? title,
    String? category,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? timestamp,
  }) {
    return WorkoutItem(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory WorkoutItem.fromJson(Map<String, dynamic> json) {
    return WorkoutItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? 'Genel',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

@immutable
class WorkoutSummaryModel {
  final int dailyCalorieGoal;
  final List<WorkoutItem> workouts;

  const WorkoutSummaryModel({
    required this.dailyCalorieGoal,
    required this.workouts,
  });

  factory WorkoutSummaryModel.initial() {
    return WorkoutSummaryModel(
      dailyCalorieGoal: 600,
      workouts: [
        WorkoutItem(
          id: '1',
          title: 'Sabah Koşusu',
          category: 'Koşu',
          durationMinutes: 25,
          caloriesBurned: 240,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        WorkoutItem(
          id: '2',
          title: 'Ağırlık & Hiit',
          category: 'Fitness',
          durationMinutes: 35,
          caloriesBurned: 210,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
      ],
    );
  }

  int get totalCaloriesBurned =>
      workouts.fold(0, (sum, item) => sum + item.caloriesBurned);

  int get totalDurationMinutes =>
      workouts.fold(0, (sum, item) => sum + item.durationMinutes);

  double get progressRatio => dailyCalorieGoal > 0
      ? (totalCaloriesBurned / dailyCalorieGoal).clamp(0.0, 1.0)
      : 0.0;

  int get remainingCalories =>
      (dailyCalorieGoal - totalCaloriesBurned).clamp(0, dailyCalorieGoal);

  WorkoutSummaryModel copyWith({
    int? dailyCalorieGoal,
    List<WorkoutItem>? workouts,
  }) {
    return WorkoutSummaryModel(
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      workouts: workouts ?? this.workouts,
    );
  }

  factory WorkoutSummaryModel.fromJson(Map<String, dynamic> json) {
    return WorkoutSummaryModel(
      dailyCalorieGoal: json['dailyCalorieGoal'] as int? ?? 600,
      workouts: (json['workouts'] as List<dynamic>?)
              ?.map((e) => WorkoutItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyCalorieGoal': dailyCalorieGoal,
      'workouts': workouts.map((w) => w.toJson()).toList(),
    };
  }
}
