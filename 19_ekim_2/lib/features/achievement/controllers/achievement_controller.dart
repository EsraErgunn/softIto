import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';

/// Haftalık takip, rozetler ve hediye hayvan durumunu yöneten denetleyici
class AchievementController {
  final ValueNotifier<AchievementModel> state =
      ValueNotifier<AchievementModel>(AchievementModel.initial());

  AchievementModel get value => state.value;

  /// Kullanıcıya puan ekler ve hak kazanılan rozet/hayvan kilitlerini açar
  void addPoints(int earnedPoints) {
    if (earnedPoints <= 0) return;
    final newPoints = state.value.totalPoints + earnedPoints;

    // Hayvanların kilit kontrolü
    final updatedPets = state.value.pets.map((pet) {
      if (!pet.isUnlocked && newPoints >= pet.requiredPoints) {
        return pet.copyWith(isUnlocked: true);
      }
      return pet;
    }).toList();

    state.value = state.value.copyWith(
      totalPoints: newPoints,
      pets: updatedPets,
    );
  }

  /// Aktif evcil hayvan / maskot seçimi
  void selectActivePet(String petId) {
    final pet = state.value.pets.firstWhere(
      (p) => p.id == petId,
      orElse: () => state.value.pets.first,
    );
    if (pet.isUnlocked) {
      state.value = state.value.copyWith(activePetId: petId);
    }
  }

  void dispose() {
    state.dispose();
  }
}
