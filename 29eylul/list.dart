void main() {
  //Büyüyebilir liste
  final List<String> aktifMikroservisler = [
    "auth-service:v2.1",
    "gatewat-service:v1.9",
    "payment-processorr:v3.0",
  ];
  aktifMikroservisler.add("telemetry-collector:v1.0");
  print(
    "Aktif servisler: (${aktifMikroservisler.length} adet): $aktifMikroservisler",
  );

  //Sabit uzunluktaki liste (fixed-length)
  final List<String> cekirdekYukDengeleyiciler = List.filled(
    4,
    "port-kapalı",
    growable: false,
  );
  cekirdekYukDengeleyiciler[0] = "LB-NODE-01; 192.168.1.10 (online)";
  cekirdekYukDengeleyiciler[1] = "LB-NODE-02; 192.168.1.11 (online)";
  // cekirdekYukDengeleyiciler.add("LB-NODE-05"); //HATA:fixed-length listeye eleman eklenemez
  print("çekirdek yük dengeleyici portları: $cekirdekYukDengeleyiciler");

//Programlamacılık List Üretici
final List<String> kubernetsPodlari =List.generate(13, (index) => "pod-node-eu-west- ${index+1} [Ram:16GB ,CPU:4 Cores]",);
print("oluşturulan k8s podları: $kubernetsPodlari");


// Değiştirilemez List
final List<String> guvenlikDuvariPortlari =List.unmodifiable(["22/TCP (SSH) ","443/TCP (HTTPS)","6443/TCP (K8s-API)",]);
// guvenlikDuvarıPortlari[0]="80/TCP"; //hata cannot modift an unmodifiable list
print("Güvenlik Duvaro Korumali Portlar: $guvenlikDuvariPortlari");

}