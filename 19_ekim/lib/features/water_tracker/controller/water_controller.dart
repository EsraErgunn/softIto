// =============================================================================
// water_controller.dart - Su takibinin iş mantığı (state yönetimi)
// ChangeNotifier: veri değişince notifyListeners() ile dinleyen widget'lara
// (ListenableBuilder / AnimatedBuilder) "yeniden çiz" haberi verir.
// UI hesap yapmaz; toplam, yüzde, kalan gibi değerleri buradan okur.
// =============================================================================

import 'package:flutter/foundation.dart';
import '../models/water_intake.dart';

class WaterController extends ChangeNotifier {
  // Varsayılan günlük hedef 2500 ml. ":" sonrası initializer list ile private alana atanır.
  WaterController({int initialGoalMl = 2500}) : _dailyGoalMl = initialGoalMl;

  int _dailyGoalMl;
  // Gün içindeki su kayıtları (private, dışarıdan doğrudan değiştirilemez).
  final List<WaterIntake> _intakes = [];

  int get dailyGoalMl => _dailyGoalMl;
  // Dışarıya salt okunur kopya verilir; UI listeye eleman ekleyemez,
  // değişiklik sadece controller metotlarıyla yapılır.
  List<WaterIntake> get intakes => List.unmodifiable(_intakes);

  // fold: listeyi tek bir değere indirger. 0'dan başlar, her kaydın ml'sini ekler.
  int get currentAmountMl {
    return _intakes.fold<int>(0, (sum, item) => sum + item.amountMl);
  }

  double get progress {
    if (_dailyGoalMl <= 0) return 0.0;
    // İlerleme oranı (0.0 - 1.0). clamp ile hedef aşılsa bile en fazla 1.0 (%100) olur.
    // Hedef 0 ise yukarıdaki kontrol sayesinde sıfıra bölme hatası olmaz.
    return (currentAmountMl / _dailyGoalMl).clamp(0.0, 1.0);
  }

  // Hedefe kalan miktar; hedef aşıldıysa negatif yerine 0 döner.
  int get remainingMl {
    final diff = _dailyGoalMl - currentAmountMl;
    return diff > 0 ? diff : 0;
  }

  bool get isGoalReached => currentAmountMl >= _dailyGoalMl;

  // Yeni su kaydı ekler. Geçersiz (0 veya negatif) miktarlar yok sayılır.
  void addIntake(int amountMl) {
    if (amountMl <= 0) return;
    // insert(0, ...): en yeni kayıt listenin başına eklenir (geçmişte en üstte görünür).
    _intakes.insert(
      0,
      WaterIntake(
        // Benzersiz id: şu anki zamanın mikrosaniye cinsinden değeri.
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amountMl: amountMl,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // Kaydı id'sine göre siler.
  void removeIntake(String id) {
    _intakes.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // Günün tüm kayıtlarını temizler.
  void reset() {
    _intakes.clear();
    notifyListeners();
  }

  // Günlük hedefi değiştirir; geçersiz değerler yok sayılır.
  void updateGoal(int newGoalMl) {
    if (newGoalMl <= 0) return;
    _dailyGoalMl = newGoalMl;
    notifyListeners();
  }
}
