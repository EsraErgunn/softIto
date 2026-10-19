import 'package:flutter/foundation.dart';
import '../models/workout_model.dart';

class WorkoutController {
  final ValueNotifier<WorkoutModel> state =
      ValueNotifier<WorkoutModel>(WorkoutModel.initial());

  WorkoutModel get current => state.value;

  void addWorkout({required int minutes, required int calories}) {
    if (minutes <= 0) return;
    state.value = current.copyWith(
      activeMinutes: current.activeMinutes + minutes,
      caloriesBurned: current.caloriesBurned + calories,
      exercisesCompleted: current.exercisesCompleted + 1,
    );
  }

  void reset() {
    state.value = current.copyWith(
      activeMinutes: 0,
      caloriesBurned: 0,
      exercisesCompleted: 0,
    );
  }

  void dispose() {
    state.dispose();
  }
}
