 void main() {
  print("Map metrikleri");

  final Map<String, Map<String, dynamic>> mikroservisRehberi = {
    "auth-api": {
      "port": 8081,
      "saglik": "Healthy",
      "restartSayisi": 0,
      "bellekKullanimMB": 384.5,
      "otonomOlcekleme": true,
    },

    "payment-gateway": {
      "port": 8082,
      "saglik": "Degraded",
      "restartSayisi": 4,
      "bellekKullanimMB": 1280.0,
      "otonomOlcekleme": false,
    },
  };
  // Yeni servis ekleme(putIfAbsent ile çakışmasız ekleme)
  mikroservisRehberi.putIfAbsent(
    "reporting-worker",
    () => {
      "port": 9091,
      "saglik": "Healthy",
      "restartSayisi": 1,
      "bellekKullanimMB": 512.0,
      "otonomOlcekleme": true,
    },
  );

  //Metrik güncelleme (update)
  if (mikroservisRehberi.containsKey("payment-gateway")) {
    mikroservisRehberi["payment-gateway"]!["restartSayisi"] =
        (mikroservisRehberi["payment-gateway"]!["restartSayisi"] as int) + 1;
  }

  print("Güncel servis Durum Raporu");
  print("------------------------------");
  for (var entry in mikroservisRehberi.entries) {
    final String servis = entry.key;
    final Map<String, dynamic> ozet = entry.value;
    final String saglik = ozet["saglik"];
    final String durumRozet = saglik == "Healthy" ? "OK" : "Alert";
    print(
      "${durumRozet.padRight(5)} ${servis.padRight(18)} | Port: ${ozet['port']} > Ram ${ozet['bellekKullanimMB']} MB | Restart: ${ozet['restartSayisi']}",
    );
  }



}

