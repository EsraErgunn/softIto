enum CihazTipi { sensor, gateway, edgeServer, router }

class CihazErisilemezException implements Exception {
  final String mesaj;

  CihazErisilemezException(this.mesaj);

  @override
  String toString() => mesaj;
}

class IoTCihaz {
  final String seriNo;
  final String cihazAdi;
  final CihazTipi tip;
  final double cpuYukYuzdesi;
  final int bellekMb;
  final Set<String> acikPortlar;
  final bool sslSertifikasiGecerliMi;
  final bool cevrimiciMi;

  const IoTCihaz({
    required this.seriNo,
    required this.cihazAdi,
    required this.tip,
    required this.cpuYukYuzdesi,
    required this.bellekMb,
    required this.acikPortlar,
    required this.sslSertifikasiGecerliMi,
    this.cevrimiciMi = true,
  });

  bool get guvenlikAcigiVarMi =>
      !sslSertifikasiGecerliMi || acikPortlar.contains("23/TELNET");

  bool get riskliMi => guvenlikAcigiVarMi || cpuYukYuzdesi > 85.0;

  @override
  String toString() =>
      "[$seriNo] $cihazAdi (${tip.name}) | CPU: %$cpuYukYuzdesi | Bellek: $bellekMb MB";
}

class IoTAgYoneticisi {
  final List<IoTCihaz> _cihazlar;

  IoTAgYoneticisi(this._cihazlar);

  List<IoTCihaz> riskliCihazlariGetir() {
    return _cihazlar.where((c) => c.riskliMi).toList();
  }

  int toplamBellekKullanimi() {
    return _cihazlar.fold(0, (toplam, c) => toplam + c.bellekMb);
  }

  (String cihazAdi, CihazTipi tip, bool alarmDurumu)? seriNoIleBul(
    String seriNo,
  ) {
    for (var c in _cihazlar) {
      if (c.seriNo == seriNo) {
        return (c.cihazAdi, c.tip, c.riskliMi);
      }
    }
    return null;
  }

  String izolasyonBolgesi(CihazTipi tip) {
    return switch (tip) {
      CihazTipi.sensor => "ZONE-S-01",
      CihazTipi.gateway => "ZONE-G-02",
      CihazTipi.edgeServer => "ZONE-E-03",
      CihazTipi.router => "ZONE-R-04",
    };
  }

  void cihazaBaglan(String seriNo) {
    final cihaz = _cihazlar.where((c) => c.seriNo == seriNo).firstOrNull;
    if (cihaz == null) {
      throw CihazErisilemezException(
        "[$seriNo] seri numaralı cihaz ağda kayıtlı değil.",
      );
    }
    if (!cihaz.cevrimiciMi) {
      throw CihazErisilemezException(
        "${cihaz.cihazAdi} [${cihaz.seriNo}] kapalı durumda, bağlantı kurulamadı.",
      );
    }
    print("${cihaz.cihazAdi} [${cihaz.seriNo}] cihazına başarıyla bağlanıldı.");
  }
}

void main() {
  print("IoT Ağ Yönetim Paneli");
  print("---------------------------------------");

  final List<IoTCihaz> cihazlar = [
    IoTCihaz(
      seriNo: "IOT-001",
      cihazAdi: "Sıcaklık Sensörü",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 12.5,
      bellekMb: 128,
      acikPortlar: {"443/HTTPS"},
      sslSertifikasiGecerliMi: true,
    ),
    IoTCihaz(
      seriNo: "IOT-002",
      cihazAdi: "Nem Sensörü",
      tip: CihazTipi.sensor,
      cpuYukYuzdesi: 8.0,
      bellekMb: 64,
      acikPortlar: {"23/TELNET", "443/HTTPS"},
      sslSertifikasiGecerliMi: true,
    ),
    IoTCihaz(
      seriNo: "IOT-003",
      cihazAdi: "Fabrika Gateway",
      tip: CihazTipi.gateway,
      cpuYukYuzdesi: 91.3,
      bellekMb: 1024,
      acikPortlar: {"443/HTTPS", "1883/MQTT"},
      sslSertifikasiGecerliMi: true,
    ),
    IoTCihaz(
      seriNo: "IOT-004",
      cihazAdi: "Edge Analiz Sunucusu",
      tip: CihazTipi.edgeServer,
      cpuYukYuzdesi: 67.8,
      bellekMb: 4096,
      acikPortlar: {"22/SSH", "443/HTTPS"},
      sslSertifikasiGecerliMi: false,
    ),
    IoTCihaz(
      seriNo: "IOT-005",
      cihazAdi: "Ana Router",
      tip: CihazTipi.router,
      cpuYukYuzdesi: 45.0,
      bellekMb: 512,
      acikPortlar: {"22/SSH", "80/HTTP", "443/HTTPS"},
      sslSertifikasiGecerliMi: true,
    ),
    IoTCihaz(
      seriNo: "IOT-006",
      cihazAdi: "Yedek Router",
      tip: CihazTipi.router,
      cpuYukYuzdesi: 5.2,
      bellekMb: 256,
      acikPortlar: {"443/HTTPS"},
      sslSertifikasiGecerliMi: true,
      cevrimiciMi: false,
    ),
  ];

  final yonetici = IoTAgYoneticisi(cihazlar);

  print("Tüm Cihazlar (${cihazlar.length}):");
  for (var c in cihazlar) {
    print("* $c");
  }
  print("---------------------------------------");

  final riskliCihazlar = yonetici.riskliCihazlariGetir();
  print("Riskli Cihazlar (${riskliCihazlar.length}):");
  for (var c in riskliCihazlar) {
    final String neden = c.guvenlikAcigiVarMi ? "Güvenlik açığı" : "Yüksek CPU";
    print("* ${c.cihazAdi} [${c.seriNo}] -> $neden");
  }
  print("---------------------------------------");

  print("Toplam Bellek Kullanımı: ${yonetici.toplamBellekKullanimi()} MB");
  print("---------------------------------------");

  print("Seri Numarası ile Cihaz Sorgulama:");
  for (var seriNo in ["IOT-003", "IOT-005", "IOT-999"]) {
    final sonuc = yonetici.seriNoIleBul(seriNo);
    if (sonuc == null) {
      print("* [$seriNo] -> Cihaz bulunamadı.");
      continue;
    }
    final (cihazAdi, tip, alarmDurumu) = sonuc;
    print(
      "* [$seriNo] -> $cihazAdi | Tip: ${tip.name} | Alarm: ${alarmDurumu ? "AKTİF" : "Yok"}",
    );
  }
  print("---------------------------------------");

  print("İzolasyon Bölgeleri:");
  for (var c in cihazlar) {
    print(
      "* ${c.cihazAdi.padRight(22)} -> ${yonetici.izolasyonBolgesi(c.tip)}",
    );
  }
  print("---------------------------------------");

  print("Cihaz Bağlantı Testi:");
  for (var seriNo in ["IOT-005", "IOT-006", "IOT-999"]) {
    try {
      yonetici.cihazaBaglan(seriNo);
    } on CihazErisilemezException catch (e) {
      print("Erişim Hatası: $e");
    } finally {
      print("[$seriNo] bağlantı denemesi tamamlandı.");
    }
  }
  print("---------------------------------------");
}
