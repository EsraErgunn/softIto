import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/achivement/controller/achivement_controller.dart';
import 'package:susadim/features/water_tracker/controller/water_controller.dart';
import 'package:susadim/features/workout/controller/workout_controller.dart';

void main() {
  group('WaterController Birim Testleri', () {
    late WaterController controller;

    setUp(() {
      controller = WaterController(initialGoalMl: 2000);
    });

    test('Başlangıç değerleri doğru olmalı', () {
      expect(controller.dailyGoalMl, 2000);
      expect(controller.currentAmountMl, 0);
      expect(controller.progress, 0.0);
      expect(controller.remainingMl, 2000);
      expect(controller.isGoalReached, false);
      expect(controller.intakes, isEmpty);
    });

    test('Su ekleme ve ilerleme hesaplama doğru çalışmalı', () {
      controller.addIntake(500);
      expect(controller.currentAmountMl, 500);
      expect(controller.progress, 0.25);
      expect(controller.remainingMl, 1500);
      expect(controller.intakes.length, 1);
    });

    test('Hedef tamamlandığında isGoalReached true olmalı', () {
      controller.addIntake(2000);
      expect(controller.isGoalReached, true);
      expect(controller.remainingMl, 0);
      expect(controller.progress, 1.0);
    });

    test('Su kaydı silme çalışmalı', () {
      controller.addIntake(250);
      final id = controller.intakes.first.id;
      controller.removeIntake(id);
      expect(controller.currentAmountMl, 0);
      expect(controller.intakes, isEmpty);
    });
  });

  group('WorkoutController Birim Testleri', () {
    late WorkoutController controller;

    setUp(() {
      controller = WorkoutController(initialCalorieGoal: 400);
    });

    test('Başlangıç değerleri doğru olmalı', () {
      expect(controller.dailyCalorieGoal, 400);
      expect(controller.totalCalories, 0);
      expect(controller.totalMinutes, 0);
      expect(controller.progress, 0.0);
      expect(controller.isGoalReached, false);
    });

    test('Antrenman ekleme ve kalori hesaplama doğru çalışmalı', () {
      controller.addWorkout(
        title: 'Koşu',
        durationMinutes: 30,
        caloriesBurned: 300,
      );
      expect(controller.totalCalories, 300);
      expect(controller.totalMinutes, 30);
      expect(controller.progress, 0.75);
      expect(controller.entries.length, 1);
    });

    test('Antrenman silme doğru çalışmalı', () {
      controller.addWorkout(
        title: 'HIIT',
        durationMinutes: 20,
        caloriesBurned: 200,
      );
      final id = controller.entries.first.id;
      controller.removeWorkout(id);
      expect(controller.totalCalories, 0);
      expect(controller.entries, isEmpty);
    });
  });

  group('AchivementController Birim Testleri', () {
    late AchivementController controller;

    setUp(() {
      controller = AchivementController();
    });

    test('Başlangıç rozet ve hayvan koleksiyonu tanımlanmalı', () {
      expect(controller.badges.isNotEmpty, true);
      expect(controller.pets.length, 4);
      expect(controller.weeklyDays.length, 7);
      expect(controller.totalPoints, greaterThan(0));
    });

    test('Aktiviteler senkronize edildiğinde rozetler açılmalı ve puan artmalı', () {
      final initialPoints = controller.totalPoints;
      controller.syncWithActivities(
        waterMl: 2500,
        waterGoalMl: 2500,
        caloriesBurned: 600,
        calorieGoal: 500,
      );

      expect(controller.totalPoints, greaterThan(initialPoints));
      // İlk damla ve hidrasyon rozetleri açılmalı
      final waterGoalBadge = controller.badges.firstWhere((b) => b.id == 'water_goal');
      expect(waterGoalBadge.isUnlocked, true);
    });

    test('Yeterli puana ulaşıldığında hayvan hediyesi açılmalı', () {
      controller.addBonusPoints(300);
      final cyberWolf = controller.pets.firstWhere((p) => p.id == 'cyber_wolf');
      expect(cyberWolf.isUnlocked, true);
    });
  });
}
