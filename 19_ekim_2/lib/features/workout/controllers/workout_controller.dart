import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

/// Egzersiz ve kalori durumunu yöneten reaktif ValueNotifier denetleyicisi
class WorkoutController {
  final ValueNotifier<WorkoutSummaryModel> state =
      ValueNotifier<WorkoutSummaryModel>(WorkoutSummaryModel.initial());

  WorkoutSummaryModel get value => state.value;

  /// Yeni bir egzersiz seansı ekler
  void addWorkout({
    required String title,
    required String category,
    required int durationMinutes,
    required int caloriesBurned,
  }) {
    final newItem = WorkoutItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim().isEmpty ? 'Egzersiz' : title.trim(),
      category: category,
      durationMinutes: durationMinutes > 0 ? durationMinutes : 15,
      caloriesBurned: caloriesBurned > 0 ? caloriesBurned : 100,
      timestamp: DateTime.now(),
    );

    final updatedList = List<WorkoutItem>.from(state.value.workouts)
      ..insert(0, newItem);

    state.value = state.value.copyWith(workouts: updatedList);
  }

  /// Belirtilen id'ye sahip egzersizi siler
  void removeWorkout(String id) {
    final updatedList =
        state.value.workouts.where((item) => item.id != id).toList();
    state.value = state.value.copyWith(workouts: updatedList);
  }

  /// Günlük kalori hedefini günceller
  void updateCalorieGoal(int newGoal) {
    if (newGoal < 200) return;
    state.value = state.value.copyWith(dailyCalorieGoal: newGoal);
  }

  /// Günlük egzersizleri sıfırlar
  void resetWorkouts() {
    state.value = state.value.copyWith(workouts: const []);
  }

  void dispose() {
    state.dispose();
  }
}
