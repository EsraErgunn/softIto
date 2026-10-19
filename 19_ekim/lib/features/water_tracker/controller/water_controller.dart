import 'package:flutter/foundation.dart';
import '../models/water_intake.dart';

class WaterController extends ChangeNotifier {
  WaterController({int initialGoalMl = 2500}) : _dailyGoalMl = initialGoalMl;

  int _dailyGoalMl;
  final List<WaterIntake> _intakes = [];

  int get dailyGoalMl => _dailyGoalMl;
  List<WaterIntake> get intakes => List.unmodifiable(_intakes);

  int get currentAmountMl {
    return _intakes.fold<int>(0, (sum, item) => sum + item.amountMl);
  }

  double get progress {
    if (_dailyGoalMl <= 0) return 0.0;
    return (currentAmountMl / _dailyGoalMl).clamp(0.0, 1.0);
  }

  int get remainingMl {
    final diff = _dailyGoalMl - currentAmountMl;
    return diff > 0 ? diff : 0;
  }

  bool get isGoalReached => currentAmountMl >= _dailyGoalMl;

  void addIntake(int amountMl) {
    if (amountMl <= 0) return;
    _intakes.insert(
      0,
      WaterIntake(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amountMl: amountMl,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeIntake(String id) {
    _intakes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void reset() {
    _intakes.clear();
    notifyListeners();
  }

  void updateGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    _dailyGoalMl = newGoalMl;
    notifyListeners();
  }
}
