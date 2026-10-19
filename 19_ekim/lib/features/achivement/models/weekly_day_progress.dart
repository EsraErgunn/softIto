import 'package:flutter/foundation.dart';

@immutable
class WeeklyDayProgress {
  final String dayName;
  final int waterMl;
  final int waterGoalMl;
  final int caloriesBurned;
  final int calorieGoal;
  final bool isToday;

  const WeeklyDayProgress({
    required this.dayName,
    required this.waterMl,
    required this.waterGoalMl,
    required this.caloriesBurned,
    required this.calorieGoal,
    this.isToday = false,
  });

  bool get isWaterCompleted => waterMl >= waterGoalMl;
  bool get isWorkoutCompleted => caloriesBurned >= calorieGoal;
  bool get isPerfectDay => isWaterCompleted && isWorkoutCompleted;
}
