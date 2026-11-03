// =============================================================================
// achievement_controller_test.dart - Başarım controller'ı birim testleri
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/achievement/controller/achievement_controller.dart';

void main() {
  group('Achievement Controller Testleri', () {
    late AchievementController controller;

    setUp(() {
      controller = AchievementController();
    });

    // tearDown: her testten SONRA çalışır; controller'ı kapatıp kaynakları temizler.
    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç durumu varsayılan rozet ve puanla açılmalıdır', () {
      expect(controller.current.totalScore, 360);
      expect(controller.current.targetScoreForPet, 500);
      expect(controller.current.awardedPet, isNull);
    });

    test('addPoints puanı artırmalı ve 500 puanda hayvan hediye edilmelidir', () {
      // 510 >= 500 olduğu için hayvan ve "Hayvan Dostu" rozeti verilmeli.
      controller.addPoints(150); // 360 + 150 = 510
      expect(controller.current.totalScore, 510);
      expect(controller.current.awardedPet, 'Akıllı Su Samuru');
      expect(controller.current.unlockedBadges.contains('Hayvan Dostu'), true);
    });

    test('reset metodu başlangıç durumuna döndürmelidir', () {
      controller.addPoints(200);
      controller.reset();
      expect(controller.current.totalScore, 360);
      expect(controller.current.awardedPet, isNull);
    });
  });
}
