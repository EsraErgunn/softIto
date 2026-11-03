// =============================================================================
// workout_controller.dart - Egzersiz/kalori durum yönetimi (ValueNotifier + immutable model)
// =============================================================================

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
      // Boş başlık, süre veya kalori girilirse makul varsayılan değerler kullanılır.
      title: title.trim().isEmpty ? 'Egzersiz' : title.trim(),
      category: category,
      durationMinutes: durationMinutes > 0 ? durationMinutes : 15,
      caloriesBurned: caloriesBurned > 0 ? caloriesBurned : 100,
      timestamp: DateTime.now(),
    );

    // Kopya liste oluşturulur, yeni kayıt başa (index 0) eklenir: en yeni en üstte görünür.
    final updatedList = List<WorkoutItem>.from(state.value.workouts)
      ..insert(0, newItem);

    state.value = state.value.copyWith(workouts: updatedList);
  }

  /// Belirtilen id'ye sahip egzersizi siler
  void removeWorkout(String id) {
    final updatedList =
        // Silme: id'si eşleşmeyenler tutulur, böylece eşleşen kayıt listeden çıkar.
        state.value.workouts.where((item) => item.id != id).toList();
    state.value = state.value.copyWith(workouts: updatedList);
  }

  /// Günlük kalori hedefini günceller
  void updateCalorieGoal(int newGoal) {
    // 200 kcal'den düşük hedefler kabul edilmez.
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
