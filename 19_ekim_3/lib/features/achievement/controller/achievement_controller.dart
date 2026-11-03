// =============================================================================
// achievement_controller.dart - Puan, rozet ve hediye hayvan mantığı
// ValueNotifier<AchievementModel> içinde immutable model tutulur; her değişiklikte
// copyWith ile yeni model atanır ve dinleyen ekran yeniden çizilir.
// =============================================================================

import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';

class AchievementController {
  final ValueNotifier<AchievementModel> state =
      ValueNotifier<AchievementModel>(AchievementModel.initial());

  AchievementModel get current => state.value;

  // Puan ekler; eşiklere ulaşılınca rozet ve hediye hayvan verir.
  void addPoints(int points) {
    if (points <= 0) return;
    final newScore = current.totalScore + points;

    String? pet = current.awardedPet;
    // Rozet listesinin kopyası alınır; orijinal (immutable modeldeki) liste değiştirilmez.
    final badges = List<String>.from(current.unlockedBadges);

    // 400 puanda "Hidrasyon Ustası" rozeti (daha önce eklenmediyse).
    if (newScore >= 400 && !badges.contains('Hidrasyon Ustası')) {
      badges.add('Hidrasyon Ustası');
    }
    // Hedef puana (500) ulaşıldıysa ve henüz hayvan verilmediyse hediye edilir.
    if (newScore >= current.targetScoreForPet && pet == null) {
      pet = 'Akıllı Su Samuru';
      if (!badges.contains('Hayvan Dostu')) {
        badges.add('Hayvan Dostu');
      }
    }

    state.value = current.copyWith(
      totalScore: newScore,
      awardedPet: pet,
      unlockedBadges: badges,
    );
  }

  // Her şeyi başlangıç değerlerine döndürür.
  void reset() {
    state.value = AchievementModel.initial();
  }

  void dispose() {
    state.dispose();
  }
}
