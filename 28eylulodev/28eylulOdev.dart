//1.Enumları (derleme Zamanı güvenliği)
// Klinikte sunulan hizmetlerin kategorilerini tutan enum
enum HizmetKategorisi { ciltYenileme, medikalEstetik, lazerEpilasyon, Lipo }

// Bir seansın o anki durumunu gösteren enum
enum SeansDurumu { bekliyor, odadaIslemde, tamamlandi, iptalEdildi }

// Danışanın kullanabileceği ödeme yöntemleri
enum OdemeYontemi { krediKarti, havaleEft, nakit, klinikPaketKredisi }

//Danışan (müşteri) Modeli
class Danisan {
  final String id; // Danışanın benzersiz kimlik numarası
  final String adSoyad; // Danışanın adı ve soyadı
  final String telefon; // Danışanın iletişim numarası
  final bool vipUyeMi; // Danışan VIP üye mi? (true/false)
  final List<String> alerjiler; // boş olabilir ama null olamaz
  final String? ozelCiltNotu; // Opsiyonel Null olabilir

  // const yapıcı metot: nesne oluşturulurken alanlara değer atanır
  const Danisan({
    required this.id, // required: zorunlu parametre
    required this.adSoyad, // zorunlu parametre
    required this.telefon, // zorunlu parametre
    this.vipUyeMi = false, // verilmezse varsayılan olarak false
    this.alerjiler = const [], // verilmezse varsayılan olarak boş liste
    this.ozelCiltNotu, // verilmezse null kalır
  });

  // Alerji listesi boş değilse danışan hassas ciltli kabul edilir
  bool get hassasCiltMi => alerjiler.isNotEmpty;

  //Bilgi özet kartı
  String get bilgiOzeti {
    // Alerji listesi boşsa uyarı metni, doluysa alerjileri virgülle birleştirir
    final String alerjiBilgisi = alerjiler.isEmpty
        ? "Kayıtlı Alerji Yok"
        : "Alerjiler: ${alerjiler.join(', ')}";
    // ?? operatörü: ozelCiltNotu null ise sağdaki varsayılan metin kullanılır
    final String notBilgisi = ozelCiltNotu ?? "Özel medikal not girilmemiş";
    // Ternary (?:) ile VIP durumuna göre rozet metni belirlenir
    final String vipRozeti = vipUyeMi ? "VİP" : "Standart";
    // Tüm bilgiler tek satırlık bir özet metin olarak döndürülür
    return "$vipRozeti $adSoyad ($telefon) | $alerjiBilgisi | Not: $notBilgisi";
  }
}

// Seans (randevu) Modeli

class SeansKaydi {
  final String seansKodu; // Seansın benzersiz kodu
  final Danisan danisan; // Seansı alan danışan nesnesi
  final HizmetKategorisi kategori; // Hizmetin kategorisi (enum)
  final String islemAdi; // Yapılacak işlemin adı
  final double birimFiyat; // Tek seansın fiyatı
  final int seansSayisi; // Toplam seans adedi
  final double indirimOrani; // Örn 10.0
  final String? sorumluUzman; // Atanan uzman, henüz atanmadıysa null
  SeansDurumu durum; // final değil: seans ilerledikçe durum değişebilir
  OdemeYontemi? odemeTipi; // Ödeme yapılana kadar null kalır

  // Yapıcı metot: zorunlu ve varsayılan değerli parametreler
  SeansKaydi({
    required this.seansKodu, // zorunlu
    required this.danisan, // zorunlu
    required this.kategori, // zorunlu
    required this.islemAdi, // zorunlu
    required this.birimFiyat, // zorunlu
    this.seansSayisi = 1, // varsayılan: 1 seans
    this.indirimOrani = 0.0, // varsayılan: indirim yok
    this.sorumluUzman, // varsayılan: null (uzman atanmamış)
    this.durum = SeansDurumu.bekliyor, // yeni seans "bekliyor" durumunda başlar
    this.odemeTipi, // varsayılan: null (henüz ödeme yok)
  });

  // İndirimsiz toplam tutar = birim fiyat x seans sayısı
  double get brutTutar => birimFiyat * seansSayisi;

  // Uygulanacak toplam indirim miktarını hesaplar
  double get indirimTutari {
    double toplamOran = indirimOrani; // Başlangıçta seansa özel indirim oranı
    if (danisan.vipUyeMi) {
      toplamOran += 10.0; // VIP danışanlara ek %10 indirim
    }
    return brutTutar * (toplamOran / 100.0); // Oranı tutara çevirir
  }

  // Ödenecek net tutar = brüt tutar - indirim tutarı
  double get netTutar => brutTutar - indirimTutari;
}

// Yönetim Servisi

class KlinikYoneticisi {
  final String subeAdi; // Klinik şubesinin adı
  final List<SeansKaydi> _seanslar = []; // _ ile başlayan: dışarıdan erişilemez (private) seans listesi
  final Map<String, Danisan> _danisanRehberi = {}; // id -> Danışan eşleşmesini tutan rehber

  // Yapıcı metot: şube adı zorunlu
  KlinikYoneticisi({required this.subeAdi});

  //Danışan kaydetme
  void danisanKaydet(Danisan danisan) {
    _danisanRehberi[danisan.id] = danisan; // Danışanı id'si ile rehbere ekler
    // Kayıt bilgisini ve üyelik tipini ekrana yazdırır
    print(
      "Rehbere Eklendi: ${danisan.adSoyad} (${danisan.vipUyeMi ? "VİP" : "Standart"})",
    );
  }

  // Yeni randevuyu seans listesine ekler
  void randevuOlustur(SeansKaydi seans) {
    _seanslar.add(seans); // Seansı listeye ekler
    // Randevu bilgisini ekrana yazdırır
    print(
      "Randevu Kaydedildi [${seans.seansKodu}]: ${seans.danisan.adSoyad}->${seans.islemAdi}",
    );
  }

  // Verilen koda sahip seansı tamamlar ve ödeme yöntemini kaydeder
  void seansiTamamla({required String seansKodu, required OdemeYontemi odeme}) {
    for (var seans in _seanslar) { // Tüm seanslar tek tek dolaşılır
      if (seans.seansKodu == seansKodu) { // Aranan kod bulunduysa
        seans.durum = SeansDurumu.tamamlandi; // Durum "tamamlandı" yapılır
        seans.odemeTipi = odeme; // Ödeme yöntemi kaydedilir
        // Tahsil edilen net tutar 2 ondalık basamakla yazdırılır
        print(
          "Seans Tamamlandı: [${seans.seansKodu}]: ${seans.netTutar.toStringAsFixed(2)} tahsil edildi (${odeme.name})",
        );
        // Not: burada return olmadığı için seans bulunsa da aşağıdaki hata mesajı yazdırılır
      }
    }
    print("Hata [$seansKodu] kodlu seans bulunamadı"); // Seans bulunamadığında hata mesajı
    return; // Metottan çıkılır
  }

  // Verilen koda sahip seansı iptal eder; iptal nedeni opsiyoneldir
  void seansiIptalEt(String seansKodu, {String? iptalNedeni}) {
    for (var seans in _seanslar) { // Tüm seanslar dolaşılır
      if (seans.seansKodu == seansKodu) { // Aranan kod bulunduysa
        seans.durum = SeansDurumu.iptalEdildi; // Durum "iptal edildi" yapılır
        // İptal nedeni null ise "Gerekçe Belirtilmedi" yazdırılır
        print(
          "Seans İptal Edildi [${seans.seansKodu}]: ${iptalNedeni ?? "Gerekçe Belirtilmedi"}",
        );
        return; // Seans bulununca döngüden ve metottan çıkılır
      }
    }
  }

  // Finansal Rapor Metotları(fonksiyonel dart)
  // Sadece tamamlanan seansların net tutarlarını toplar
  double get toplamTahsilEdilenCiro => _seanslar
      .where((s) => s.durum == SeansDurumu.tamamlandi) // Tamamlananları filtreler
      .fold(0.0, (toplam, s) => toplam + s.netTutar); // 0.0'dan başlayarak net tutarları toplar

  // Bekleyen veya işlemdeki seansların (henüz tahsil edilmemiş) tutarını toplar
  double get beklenenPotansiyelCiro => _seanslar
      .where(
        (s) =>
            s.durum == SeansDurumu.bekliyor || // Bekleyen seanslar
            s.durum == SeansDurumu.odadaIslemde, // veya odada işlemde olanlar
      )
      .fold(0.0, (toplam, s) => toplam + s.netTutar); // Net tutarlar toplanır

  // kategori bazlı seans sayıları

  Map<HizmetKategorisi, int> kategoriBazliSeansDagilimi() {
    final Map<HizmetKategorisi, int> dagilim = {}; // Kategori -> seans sayısı haritası
    for (var kat in HizmetKategorisi.values) { // Tüm kategoriler dolaşılır
      dagilim[kat] = 0; // Her kategori başlangıçta 0 olarak ayarlanır
    }
    for (var s in _seanslar) { // Tüm seanslar dolaşılır
      dagilim[s.kategori] = (dagilim[s.kategori] ?? 0) + 1; // İlgili kategorinin sayısı 1 artırılır
    }
    return dagilim; // Sonuç haritası döndürülür
  }

  // Seanslara atanmış uzmanların tekrarsız listesini döndürür
  Set<String> gorevliUzmanKadrosu() {
    // map ile uzman adları alınır, whereType<String> null'ları eler, toSet tekrarları kaldırır
    return _seanslar.map((s) => s.sorumluUzman).whereType<String>().toSet();
  }

  //Uzmansız kalan seanslar
  List<SeansKaydi> uzmansizSeanslariGetir() {
    // Uzmanı null olan seansları filtreleyip liste olarak döndürür
    return _seanslar.where((s) => s.sorumluUzman == null).toList();
  }

  // Gün sonu raporunu tablo şeklinde ekrana yazdırır
  void gunSonuRaporuYazdir() {
    print("Günlük Seans ve İşlem Çizelgesi"); // Rapor başlığı
    print("---------------------------------------"); // Ayraç çizgisi
    // Tablo başlıkları; padRight ile sütunlar sabit genişliğe tamamlanır
    print(
      "${'Kod'.padRight((10))} | "
      "${'Danışan'.padRight(16)} | "
      "${'İşlem'.padRight(20)} | "
      "${'Uzman'.padRight(18)} | "
      "${'Tutar'.padRight(10)} | "
      "${'Durum'} | ",
    );
    print("---------------------------------------"); // Ayraç çizgisi

    for (var s in _seanslar) { // Her seans için bir satır yazdırılır
      final String uzman = s.sorumluUzman ?? " Nöbetçi Bekliyor"; // Uzman yoksa varsayılan metin
      // switch ifadesi ile enum değerine göre okunabilir durum metni seçilir
      final String durumRozet = switch (s.durum) {
        SeansDurumu.tamamlandi => "Tamamlandı",
        SeansDurumu.odadaIslemde => "İşlemde",
        SeansDurumu.bekliyor => "Bekliyor",
        SeansDurumu.iptalEdildi => "İptal",
      };

      // Seans bilgileri tablo satırı olarak yazdırılır
      print(
        "${s.seansKodu.padRight(10)} | "
        "${s.danisan.adSoyad.padRight(10)} | "
        "${s.islemAdi.padRight(10)} | "
        "${uzman.padRight(10)} | "
        "${s.netTutar.toStringAsFixed(2).padRight(10)} | "
        "$durumRozet",
      );
    }

    print("---------------------------------------"); // Ayraç çizgisi
    print("Finansal Özet:"); // Finansal özet başlığı
    // Tahsil edilmiş toplam ciro yazdırılır
    print(
      " * Gerçekleşen (kasadaki net ciro) : ${toplamTahsilEdilenCiro.toStringAsFixed(2)}",
    );
    // Henüz tahsil edilmemiş potansiyel ciro yazdırılır
    print(
      " * Bekleyen Potansiyen Alacak : ${beklenenPotansiyelCiro.toStringAsFixed(2)}",
    );
    print(" * Toplam Seans : ${_seanslar.length} Randevu"); // Toplam seans sayısı
    print("---------------------------------------"); // Ayraç çizgisi
    print("Aktif Uzmanlar"); // Uzmanlar başlığı
    final uzmanlar = gorevliUzmanKadrosu(); // Görevli uzmanlar alınır
    if (uzmanlar.isEmpty) { // Hiç uzman yoksa
      print("Kayıtlı Uzman Bulunamadı");
    } else { // Uzman varsa virgülle birleştirilip yazdırılır
      print(" ${uzmanlar.join(', ')}");
    }
    final uzmansizlar = uzmansizSeanslariGetir(); // Uzman atanmamış seanslar alınır
    if (uzmansizlar.isNotEmpty) { // Uzmansız seans varsa uyarı verilir
      print(
        "Dikkat: ${uzmansizlar.length} adet seansa henüz uzman atanmamıştır",
      );
      for (var u in uzmansizlar) { // Her uzmansız seans listelenir
        print("->[${u.seansKodu}] ${u.danisan.adSoyad} (${u.islemAdi})");
      }
    }
    print("---------------------------------------"); // Rapor sonu ayraç çizgisi
  }
}

// Programın başlangıç noktası
void main() {
  print("Klinik yönetim sistemi başlatılıyor...."); // Açılış mesajı
  final yonetici = KlinikYoneticisi(subeAdi: "Softito Bağcılar Şubesi"); // Yönetici nesnesi oluşturulur

  //danışanları oluşturalım
  // 1. danışan: VIP, alerjili ve özel notlu
  final d1 = Danisan(
    id: "DAN-101",
    adSoyad: "Ahmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );
  // 2. danışan: standart üye, alerjisi yok, özel notu yok
  final d2 = Danisan(
    id: "DAN-102",
    adSoyad: "Ahmet Yılan",
    telefon: "0555 555 55 55",
    vipUyeMi: false,
    alerjiler: [],
  );
  // 3. danışan: VIP ve alerjili, özel notu yok
  final d3 = Danisan(
    id: "DAN-103",
    adSoyad: "Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: ["Retinol,Aspirin"],
  );
  // 4. danışan: VIP, alerjisi yok, özel notlu
  final d4 = Danisan(
    id: "DAN-104",
    adSoyad: "Ahmet Mehmet Yılmaz",
    telefon: "0555 555 55 55",
    vipUyeMi: true,
    alerjiler: [],
    ozelCiltNotu: "Cilt bariyeri hassas",
  );

  // Danışanlar rehbere kaydedilir
  yonetici.danisanKaydet(d1);
  yonetici.danisanKaydet(d2);
  yonetici.danisanKaydet(d3);
  yonetici.danisanKaydet(d4);

  print("Danışan güvenlik kontrolü"); // Güvenlik kontrolü başlığı
  print(d1.bilgiOzeti); // 1. danışanın özet bilgisi
  print(d2.bilgiOzeti); // 2. danışanın özet bilgisi
  print("----------------------------------"); // Ayraç çizgisi

  // randevular oluşturuluyor
  // 1. seans: Lipo işlemi, 2 seans, %5 indirim, uzman atanmış
  final seans1 = SeansKaydi(
    seansKodu: "SNS-2026-1",
    danisan: d1,
    kategori: HizmetKategorisi.Lipo,
    islemAdi: "Lipo gerisini bilmiyorum",
    birimFiyat: 6500.0,
    seansSayisi: 2,
    indirimOrani: 5.0,
    sorumluUzman: "Sümeyye Arab",
  );
  // 2. seans: cilt yenileme, 5 seans, %15 indirim, uzman atanmamış
  final seans2 = SeansKaydi(
    seansKodu: "SNS-2026-2",
    danisan: d2,
    kategori: HizmetKategorisi.ciltYenileme,
    islemAdi: "Siverex ile tyüz temizleme",
    birimFiyat: 2500.0,
    seansSayisi: 5,
    indirimOrani: 15.0,
    sorumluUzman: null,
  );
  // 3. seans: lazer epilasyon, 15 seans, indirimsiz
  final seans3 = SeansKaydi(
    seansKodu: "SNS-2026-3",
    danisan: d3,
    kategori: HizmetKategorisi.lazerEpilasyon,
    islemAdi: "Tüm Vücut",
    birimFiyat: 25000.0,
    seansSayisi: 15,
    indirimOrani: 0.0,
    sorumluUzman: "Tuba Aydın",
  );
  // 4. seans: medikal estetik, 3 seans, indirim oranı varsayılan (0.0)
  final seans4 = SeansKaydi(
    seansKodu: "SNS-2026-4",
    danisan: d4,
    kategori: HizmetKategorisi.medikalEstetik,
    islemAdi: "Burun Estetiği",
    birimFiyat: 1500.0,
    seansSayisi: 3,
    sorumluUzman: "Alaaddin Odabaşı",
  );
  // Seanslar sisteme randevu olarak eklenir
  yonetici.randevuOlustur(seans1);
  yonetici.randevuOlustur(seans2);
  yonetici.randevuOlustur(seans3);
  yonetici.randevuOlustur(seans4);
  print("Seanslar Gönderiliyor");

  //seans 1 başarıyla tamamlanıyor (kredi kartı ile ödeme);
  yonetici.seansiTamamla(
    seansKodu: "SNS-2026-1",
    odeme: OdemeYontemi.krediKarti,
  );
  //seans 2 başarıyla tamamlanıyor (nakit ödeme);
  yonetici.seansiTamamla(seansKodu: "SNS-2026-2", odeme: OdemeYontemi.nakit);
  //seans 4 iptal ediliyor
  // Not: kod "SNS-2026-04" yazıldığı için "SNS-2026-4" ile eşleşmez, seans iptal edilmez
  yonetici.seansiIptalEt(
    "SNS-2026-04",
    iptalNedeni: "Danışanın şehir dışından tanıdığı geldiği için gelemedi",
  );

  yonetici.gunSonuRaporuYazdir(); // Gün sonu raporu yazdırılır
}
