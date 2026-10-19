import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracker/controller/water_tracker_controller.dart';

void main() {
  group('WaterTracker Controller Testleri', () {
    late WaterTrackerController controller;

    setUp(() {
      controller = WaterTrackerController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu varsayılan hedeflerle açılmalıdır', () {
      expect(controller.current.currentWaterMl, 0);
      expect(controller.current.dailyGoalMl, 2000);
      expect(controller.current.isGoalReached, false);
    });

    test('addWater metodu su miktarını ve haftalık puanı artırmalıdır', () {
      controller.addWater(250);
      expect(controller.current.currentWaterMl, 250);
      expect(controller.current.weeklyPoints, 250); // 240 + 10
    });

    test('Hedefe ulaşıldığında ve 500 puana gelindiğinde hayvan hediye edilmelidir', () {
      controller.addWater(2000); // 2000 / 25 = 80 + 50 bonus = 130 + 240 = 370
      controller.addWater(3500); // Ek puanlarla 500'ü aşar
      expect(controller.current.isGoalReached, true);
      expect(controller.current.unlockedPetName, 'Akıllı Su Samuru');
    });

    test('resetWater metodu sadece günlük tüketimi sıfırlamalıdır', () {
      controller.addWater(500);
      controller.resetWater();
      expect(controller.current.currentWaterMl, 0);
    });
  });
}
