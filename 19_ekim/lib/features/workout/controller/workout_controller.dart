import 'package:flutter/foundation.dart';
import '../models/workout_entry.dart';

class WorkoutController extends ChangeNotifier {
  WorkoutController({int initialCalorieGoal = 500})
      : _dailyCalorieGoal = initialCalorieGoal;

  int _dailyCalorieGoal;
  final List<WorkoutEntry> _entries = [];

  int get dailyCalorieGoal => _dailyCalorieGoal;
  List<WorkoutEntry> get entries => List.unmodifiable(_entries);

  int get totalCalories {
    return _entries.fold<int>(0, (sum, item) => sum + item.caloriesBurned);
  }

  int get totalMinutes {
    return _entries.fold<int>(0, (sum, item) => sum + item.durationMinutes);
  }

  double get progress {
    if (_dailyCalorieGoal <= 0) return 0.0;
    return (totalCalories / _dailyCalorieGoal).clamp(0.0, 1.0);
  }

  bool get isGoalReached => totalCalories >= _dailyCalorieGoal;

  void addWorkout({
    required String title,
    required int durationMinutes,
    required int caloriesBurned,
  }) {
    if (durationMinutes <= 0 || caloriesBurned <= 0) return;
    _entries.insert(
      0,
      WorkoutEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        durationMinutes: durationMinutes,
        caloriesBurned: caloriesBurned,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeWorkout(String id) {
    _entries.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void reset() {
    _entries.clear();
    notifyListeners();
  }

  void updateGoal(int newGoal) {
    if (newGoal <= 0) return;
    _dailyCalorieGoal = newGoal;
    notifyListeners();
  }
}
