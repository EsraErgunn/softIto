// =============================================================================
// workout_controller_test.dart - Egzersiz controller'ı birim testleri
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';

void main() {
  group('Workout Controller Testleri', () {
    late WorkoutController controller;

    setUp(() {
      controller = WorkoutController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu varsayılan değerlerle açılmalıdır', () {
      expect(controller.current.activeMinutes, 20);
      expect(controller.current.caloriesBurned, 180);
      expect(controller.current.targetMinutes, 45);
    });

    test('addWorkout değeri ve kalori miktarını artırmalıdır', () {
      // Başlangıç (20 dk, 180 kcal, 1 egzersiz) üzerine eklenir -> 35 dk, 300 kcal, 2 egzersiz.
      controller.addWorkout(minutes: 15, calories: 120);
      expect(controller.current.activeMinutes, 35);
      expect(controller.current.caloriesBurned, 300);
      expect(controller.current.exercisesCompleted, 2);
    });

    test('reset metodu değerleri sıfırlamalıdır', () {
      controller.reset();
      expect(controller.current.activeMinutes, 0);
      expect(controller.current.caloriesBurned, 0);
      expect(controller.current.exercisesCompleted, 0);
    });
  });
}
