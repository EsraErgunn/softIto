import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';

class AchievementController {
  final ValueNotifier<AchievementModel> state =
      ValueNotifier<AchievementModel>(AchievementModel.initial());

  AchievementModel get current => state.value;

  void addPoints(int points) {
    if (points <= 0) return;
    final newScore = current.totalScore + points;

    String? pet = current.awardedPet;
    final badges = List<String>.from(current.unlockedBadges);

    if (newScore >= 400 && !badges.contains('Hidrasyon Ustası')) {
      badges.add('Hidrasyon Ustası');
    }
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

  void reset() {
    state.value = AchievementModel.initial();
  }

  void dispose() {
    state.dispose();
  }
}
