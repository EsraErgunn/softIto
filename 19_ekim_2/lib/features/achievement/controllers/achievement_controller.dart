// =============================================================================
// achievement_controller.dart - Puan, rozet ve evcil hayvan durumunun yönetimi
// Tüm durum tek bir immutable AchievementModel içinde tutulur. Her değişiklikte
// copyWith ile YENİ model üretilip state.value'ya atanır; ValueNotifier eski ve
// yeni nesne farklı olduğu için dinleyicilere haber verir.
// =============================================================================

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
    // Yeni puanla eşiği geçen kilitli petler açılır; diğerleri aynen kalır.
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
      // firstWhere bulamazsa hata fırlatır; orElse ile ilk pet varsayılan olarak döner.
      orElse: () => state.value.pets.first,
    );
    // Sadece kilidi açılmış pet aktif maskot seçilebilir.
    if (pet.isUnlocked) {
      state.value = state.value.copyWith(activePetId: petId);
    }
  }

  void dispose() {
    state.dispose();
  }
}
