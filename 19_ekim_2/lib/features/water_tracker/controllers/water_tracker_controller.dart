// =============================================================================
// water_tracker_controller.dart - Su takibi durum yönetimi (ValueNotifier + immutable model)
// Model değiştirilmez; her işlemde copyWith ile yeni model üretilip state.value'ya atanır.
// =============================================================================

import 'package:flutter/foundation.dart';
import '../models/water_tracker_model.dart';

/// Su takibi mantığını ve ValueNotifier reaktif durumunu yöneten denetleyici
class WaterTrackerController {
  final ValueNotifier<WaterTrackerModel> state =
      ValueNotifier<WaterTrackerModel>(WaterTrackerModel.initial());

  WaterTrackerModel get value => state.value;

  /// Belirtilen miktarda su ekler (örn: 250ml, 500ml)
  void addWater(int amountMl) {
    if (amountMl <= 0) return;
    // Eski liste kopyalanır ve ".." (cascade) ile kopyaya ekleme yapılır.
    // Aynı listeyi değiştirmek yerine yeni liste vermek, ValueNotifier'ın değişikliği algılaması için şart.
    final updatedHistory = List<int>.from(state.value.intakeHistory)..add(amountMl);
    state.value = state.value.copyWith(
      consumedMl: state.value.consumedMl + amountMl,
      lastUpdated: DateTime.now(),
      intakeHistory: updatedHistory,
    );
  }

  /// Son eklenen suyu geri alır
  // Geri al: geçmişteki son kaydı çıkarıp toplamdan düşer.
  void removeLastIntake() {
    if (state.value.intakeHistory.isEmpty) return;
    final updatedHistory = List<int>.from(state.value.intakeHistory);
    final lastAmount = updatedHistory.removeLast();
    // clamp: sonuç negatife düşmesin diye 0 ile sınırlanır.
    final newConsumed = (state.value.consumedMl - lastAmount).clamp(0, 99999);
    state.value = state.value.copyWith(
      consumedMl: newConsumed,
      lastUpdated: DateTime.now(),
      intakeHistory: updatedHistory,
    );
  }

  /// Günlük su hedefini günceller
  void updateDailyGoal(int newGoalMl) {
    // 500 ml'den düşük hedefler mantıksız kabul edilip yok sayılır.
    if (newGoalMl < 500) return;
    state.value = state.value.copyWith(
      dailyGoalMl: newGoalMl,
      lastUpdated: DateTime.now(),
    );
  }

  /// Günlük sayacı sıfırlar
  void resetWater() {
    state.value = state.value.copyWith(
      consumedMl: 0,
      lastUpdated: DateTime.now(),
      // Sıfırlamada geçmiş boş listeyle değiştirilir.
      intakeHistory: const [],
    );
  }

  void dispose() {
    state.dispose();
  }
}
