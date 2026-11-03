// =============================================================================
// quiz.dart - Dart Event Loop (Olay Döngüsü) Sıralama Quizi
// -----------------------------------------------------------------------------
// Dart tek iş parçacıklı (single-thread) çalışır ve işleri şu sırayla yürütür:
//   1) Senkron kod: main() içindeki normal satırlar, yukarıdan aşağıya hemen çalışır.
//   2) Microtask Queue (VIP kuyruk): senkron kod bitince, event kuyruğundan
//      ÖNCE tamamen boşaltılır. (scheduleMicrotask, Future.microtask)
//   3) Event Queue (normal kuyruk): Future(), Future.delayed, Timer, I/O...
//      Her event'ten sonra tekrar microtask kuyruğuna bakılır.
//
// Beklenen çıktı sırası:
//   [1] [10]          -> senkron kodlar
//   [3] [4] [9]       -> microtask'lar (eklenme sırasıyla)
//   [2]               -> 1. event
//   [5]               -> Duration.zero timer'ı (Future()'lar ile aynı sırada kuyruğa girer)
//   [6] [8] [7]       -> 2. Future; then() bloğu Future tamamlanınca hemen
//                        çalışır, Future içinde eklenen microtask ondan sonra gelir.
// =============================================================================
import 'dart:async';

// main 'async' çünkü en sonda await ile programın kapanmasını geciktiriyoruz.
void main() async {
  // Senkron: anında çalışır.
  print('[1] Senkron Ana Akış Başladı (Main Thread)');

  // Event Queue'ya eklenir; senkron kod ve tüm microtask'lar bitince çalışır.
  Future(() {
    print('[2] Standart Future Görevi (Event Queue 1)');
  });

  // Microtask Queue'ya eklenir; event'lerden önce çalışır.
  scheduleMicrotask(() {
    print('[3] scheduleMicrotask Görevi (Microtask Queue 1)');
  });

  // Future.microtask da Microtask Queue kullanır (scheduleMicrotask ile aynı kuyruk).
  Future.microtask(() {
    print('[4] Future.microtask Görevi (Microtask Queue 2)');
  });

  // Süre 0 olsa bile Timer tabanlıdır, yani Event Queue'ya gider.
  Future.delayed(Duration.zero, () {
    print('[5] Future.delayed(Duration.zero) (Event Queue - Timer Bazlı)');
  });

  // Event Queue'daki ikinci Future.
  Future(() {
    print('[6] Standart Future Başladı (Event Queue 2)');
    // Bir event çalışırken eklenen microtask, sıradaki event'ten önce çalışır.
    scheduleMicrotask(() {
      print('[7] Future İçinden Tetiklenen Microtask (Öncelik Kapar!)');
    });
  }).then((_) {
    // then() Future tamamlandığı anda çağrılır.
    print('[8] Future then() Bloğu');
  });

  // Microtask Queue'ya üçüncü görev.
  scheduleMicrotask(() {
    print('[9] İkinci scheduleMicrotask Görevi (Microtask Queue 3)');
  });

  // Senkron: [1]'den hemen sonra çalışır.
  print('[10] Senkron Ana Akış Bitti (Main Thread Boşaldı)\n');

  // Tüm kuyruklar boşalana kadar programın kapanmaması için kısa bekleme.
  await Future.delayed(const Duration(milliseconds: 500));
}
