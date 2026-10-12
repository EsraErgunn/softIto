/*
Future<void> fetchDashboardData() async {
  try {
    final result = await Future.wait([
      fetchUserProfile(),
      fetchAccountBalance(),
      fetchNotification(),
    ], eagerError: true);

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
  final controller = StreamController<int>();
  //dinamik (listenir) bağlama
  final subscription = controller.stream.listen(
    (data) => print("Veri Geldi:$data"),
    onError: (err) => print("Hata Geldi:$err"),
    onDone: () => print("Yayın Tamamlandı"),
  );

  controller.sink.add(10);
  controller.sink.add(20);
  controller.sink.add(30);

  final broadcastStream = controller.stream.asBroadcastStream();
  broadcastStream.listen((d) => print("UI Ekranı: $d"));
  broadcastStream.listen((d) => print("Analitik Servisi Ekranı: $d"));

  controller.close();
}
