import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(WaterTrackerModel.initial());

  WaterTrackerModel get current => state.value;

  void addWater(int amountMl) {
    if (amountMl <= 0) return;

    final newWater = current.currentWaterMl + amountMl;
    final reachedNow = newWater >= current.dailyGoalMl && !current.isGoalReached;
    final earnedPoints = (amountMl ~/ 25) + (reachedNow ? 50 : 0);
    final updatedPoints = current.weeklyPoints + earnedPoints;

    // 500 puanda Akıllı Su Samuru kilidi açılır
    String? pet = current.unlockedPetName;
    if (updatedPoints >= 500 && pet == null) {
      pet = 'Akıllı Su Samuru';
    }

    final newStreak = reachedNow
        ? current.completedDaysStreak + 1
        : current.completedDaysStreak;

    state.value = current.copyWith(
      currentWaterMl: newWater,
      weeklyPoints: updatedPoints,
      completedDaysStreak: newStreak,
      unlockedPetName: pet,
    );
  }

  void resetWater() {
    state.value = current.copyWith(
      currentWaterMl: 0,
    );
  }

  void dispose() {
    state.dispose();
  }
}
