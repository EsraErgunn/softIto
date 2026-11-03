// =============================================================================
// paralel.dart - Future.wait (paralel istekler) ve Stream (veri akışı)
// -----------------------------------------------------------------------------
// Yorumdaki örnek: Future.wait ile birbirinden bağımsız istekler aynı anda
// başlatılır; toplam süre "en yavaş isteğin süresi" kadar olur (sırayla
// await etmekten çok daha hızlı).
// Aktif kod: StreamController ile bir veri akışı oluşturup birden fazla
// dinleyiciye (UI, Analitik) aynı veriyi göndermek.
// =============================================================================

/*
// Ekran açılırken profil, bakiye ve bildirimleri AYNI ANDA çeker.
Future<void> fetchDashboardData() async {
  try {
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true); // eagerError: biri hata verirse diğerlerini beklemeden hemen catch'e düşer.

    // result bir List'tir; sırası, Future'ların verildiği sırayla aynıdır.
    print("Tüm veriler geldi: $result");
  } catch (e) {
    print("İsteklerden Biri başarısız oldu $e");
  }
}
*/

//Future:Tek bir kere veri çekecileceği zaman kullanılır ya hata yada değer döndürüp bitirir.
//Stream:Bir boru hattı şeklinde çalışır (pipe) , zaman içinde 1 10 100 yada sonsuz sayıda veri akışı sağlayabilir.
//(Borsa fiyatları, GPS konum güncelleme, firebase, canlı dinleme gibi)

import 'dart:async';

void main() {
  // controller oluşturma
  // Birden fazla dinleyici olacağı için broadcast controller kullanılır.
  // Normal (single-subscription) stream sadece 1 kez dinlenebilir,
  // ikinci listen "Stream has already been listened to" hatası verir.
  final controller = StreamController<int>.broadcast();

  // Broadcast stream'de dinleyiciler veri gönderilmeden ÖNCE bağlanmalı,
  // sonradan bağlanan dinleyici önceki verileri kaçırır.
  //dinamik (listenir) bağlama
  controller.stream.listen(
    (data) => print("Veri Geldi:$data"),
    onError: (err) => print("Hata Geldi:$err"),
    onDone: () => print("Yayın Tamamlandı"),
  );
  controller.stream.listen((d) => print("UI Ekranı: $d"));
  controller.stream.listen((d) => print("Analitik Servisi Ekranı: $d"));

  // sink.add ile akışa veri gönderilir; her veri tüm dinleyicilere ulaşır.
  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  // Yayını kapatır: dinleyicilerin onDone'ı tetiklenir. Kapatılmayan
  // controller'lar bellek sızıntısına (memory leak) yol açar.
  controller.close();
}
