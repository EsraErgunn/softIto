import 'package:flutter/foundation.dart';

@immutable
class WorkoutModel {
  final int activeMinutes;
  final int targetMinutes;
  final int caloriesBurned;
  final int targetCalories;
  final int exercisesCompleted;

  const WorkoutModel({
    required this.activeMinutes,
    required this.targetMinutes,
    required this.caloriesBurned,
    required this.targetCalories,
    required this.exercisesCompleted,
  });

  factory WorkoutModel.initial() {
    return const WorkoutModel(
      activeMinutes: 20,
      targetMinutes: 45,
      caloriesBurned: 180,
      targetCalories: 400,
      exercisesCompleted: 1,
    );
  }

  double get minutesRatio =>
      (activeMinutes / (targetMinutes > 0 ? targetMinutes : 1)).clamp(0.0, 1.0);
  double get caloriesRatio =>
      (caloriesBurned / (targetCalories > 0 ? targetCalories : 1)).clamp(0.0, 1.0);

  WorkoutModel copyWith({
    int? activeMinutes,
    int? targetMinutes,
    int? caloriesBurned,
    int? targetCalories,
    int? exercisesCompleted,
  }) {
    return WorkoutModel(
      activeMinutes: activeMinutes ?? this.activeMinutes,
      targetMinutes: targetMinutes ?? this.targetMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      targetCalories: targetCalories ?? this.targetCalories,
      exercisesCompleted: exercisesCompleted ?? this.exercisesCompleted,
    );
  }

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      activeMinutes: json['activeMinutes'] as int? ?? 0,
      targetMinutes: json['targetMinutes'] as int? ?? 45,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      targetCalories: json['targetCalories'] as int? ?? 400,
      exercisesCompleted: json['exercisesCompleted'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeMinutes': activeMinutes,
      'targetMinutes': targetMinutes,
      'caloriesBurned': caloriesBurned,
      'targetCalories': targetCalories,
      'exercisesCompleted': exercisesCompleted,
    };
  }
}
