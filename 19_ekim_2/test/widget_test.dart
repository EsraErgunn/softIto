import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/constants/app_strings.dart';
import 'package:susadim/core/theme/theme_controller.dart';
import 'package:susadim/features/water_tracker/controllers/water_tracker_controller.dart';
import 'package:susadim/features/workout/controllers/workout_controller.dart';
import 'package:susadim/main.dart';

void main() {
  group('Susadım v1 Unit & Widget Testleri', () {
    test('ThemeController tema modu değiştirme testi', () {
      final themeController = ThemeController();
      expect(themeController.currentMode, ThemeMode.system);

      themeController.toggleTheme();
      expect(themeController.currentMode, ThemeMode.dark);

      themeController.toggleTheme();
      expect(themeController.currentMode, ThemeMode.light);

      themeController.toggleTheme();
      expect(themeController.currentMode, ThemeMode.system);

      themeController.setThemeMode(ThemeMode.dark);
      expect(themeController.currentMode, ThemeMode.dark);

      themeController.dispose();
    });

    test('WaterTrackerController su ekleme ve sıfırlama testi', () {
      final controller = WaterTrackerController();
      final initialConsumed = controller.value.consumedMl;

      controller.addWater(250);
      expect(controller.value.consumedMl, initialConsumed + 250);

      controller.removeLastIntake();
      expect(controller.value.consumedMl, initialConsumed);

      controller.resetWater();
      expect(controller.value.consumedMl, 0);

      controller.dispose();
    });

    test('WorkoutController egzersiz ekleme ve silme testi', () {
      final controller = WorkoutController();
      final initialCount = controller.value.workouts.length;

      controller.addWorkout(
        title: 'Gece Koşusu',
        category: 'Koşu',
        durationMinutes: 30,
        caloriesBurned: 300,
      );

      expect(controller.value.workouts.length, initialCount + 1);
      expect(controller.value.workouts.first.title, 'Gece Koşusu');

      final addedId = controller.value.workouts.first.id;
      controller.removeWorkout(addedId);
      expect(controller.value.workouts.length, initialCount);

      controller.dispose();
    });

    testWidgets('SusadimApp başlatma ve temel arayüz duman testi',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SusadimApp());
      await tester.pump();

      // Uygulama başlığı ve tab etiketlerinin varlığı kontrol edilir
      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text(AppStrings.tabWater), findsOneWidget);
      expect(find.text(AppStrings.tabWorkout), findsOneWidget);
      expect(find.text(AppStrings.tabWeekly), findsOneWidget);

      // Tema değiştirme butonunun varlığı ve tıklanabilirliği doğrulanır
      final themeToggleFinder = find.byType(IconButton);
      expect(themeToggleFinder, findsWidgets);
      await tester.tap(themeToggleFinder.first);
      await tester.pumpAndSettle();
    });
  });
}
