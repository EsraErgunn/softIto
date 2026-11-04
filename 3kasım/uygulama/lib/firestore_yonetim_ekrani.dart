// =============================================================================
// firestore_yonetim_ekrani.dart - Öğrenci kayıtlarını Cloud Firestore'da yöneten ekran
// =============================================================================
//
// NE YAPTIK, NEDEN YAPTIK?
// -----------------------------------------------------------------------------
// 1) 3 Kasım dersinde yazılanları main dalına getirdik.
//    - git checkout main  -> yerelde main dalına geçtik.
//    - git pull origin main -> GitHub'daki main'in son halini (3 Kasım PR'ı dahil)
//      bilgisayara indirdik.
//
// 2) Projeyi derlenebilir hale getirdik.
//    - pubspec.yaml'da "sdk: ^3.13.5" vardı, bilgisayardaki Dart 3.10.1 olduğu için
//      paketler inmiyordu. Kısıtı "^3.10.0" yaptık.
//    - flutter pub get -> firebase_core ve cloud_firestore paketlerini indirdi.
//    - Bu dosyada parantezler yanlış kapanmıştı: Divider ve StreamBuilder,
//      Column'un children listesinin DIŞINDA kalmıştı. Ayrıca bir Padding'in
//      içinde iki child vardı. Ağaç yapısını düzelttik.
//    - main.dart, var olmayan "FirestoreUygulamasi" sınıfını çağırıyordu ve bu
//      dosyayı import etmiyordu. Doğru sınıfı (FirestoreYonetimEkrani) çağırdık.
//    - test/widget_test.dart, projede olmayan sayaç uygulamasını (MyApp) test
//      ediyordu. Yerine not güncelleme penceresini test eden bir test yazdık
//      (Firebase gerektirmediği için bilgisayarda çalıştırılabiliyor).
//
// 3) Ödevdeki "yapılacaklar" listesini tamamladık.
//    - Proje adı alanı Expanded içine alındı ve not alanıyla yan yana dizildi.
//    - _notuGuncelleDialog fonksiyonu yazıldı: kalem ikonuna basınca açılan
//      pencereden öğrencinin notu Firestore'da güncellenebiliyor.
//    - Kaydetme ve güncellemede not 0-100 aralığında mı diye kontrol ediliyor,
//      Firestore hatası olursa ekranda mesaj gösteriliyor.
//
// 4) Kontrol için çalıştırdığımız komutlar:
//    - dart analyze -> kodda hata/uyarı var mı diye tarar.
//    - flutter test -> test klasöründeki testleri çalıştırır.
//
// NOT: Uygulamanın gerçek bir telefonda çalışması için Firebase projesine
// bağlanması gerekir ("flutterfire configure" komutu ya da Android için
// android/app/google-services.json dosyası). Bu dosyalar projede henüz yok.
//
// EKRANIN ÇALIŞMA MANTIĞI
// -----------------------------------------------------------------------------
//   Üst kısım : form (ad soyad, proje adı, not) + "Buluta Kaydet" butonu
//   Alt kısım : Firestore'daki öğrenciler CANLI olarak listelenir (StreamBuilder).
//               Buluta bir kayıt eklenince, silinince ya da güncellenince liste
//               sayfayı yenilemeye gerek kalmadan kendiliğinden değişir.
//   Sola kaydırma : kaydı siler (Dismissible)
//   Kalem ikonu   : notu güncelleme penceresini açar
// =============================================================================

// Flutter'ın hazır arayüz bileşenleri (Scaffold, TextField, ListView...).
import 'package:flutter/material.dart';
// Firestore sınıfları: FirebaseFirestore, QuerySnapshot, DocumentSnapshot.
import 'package:cloud_firestore/cloud_firestore.dart';

// OgrenciModel (veri modeli) ve FireStoreOgrenciServisi (veritabanı işlemleri).
import 'models/ogrenci_model.dart';

// StatefulWidget: içinde değişen veriler (form controller'ları) olduğu için seçildi.
class FirestoreYonetimEkrani extends StatefulWidget {
  // const constructor; key, Flutter'ın widget'ı ağaçta tanıması için kullanılır.
  const FirestoreYonetimEkrani({super.key});

  // Ekranın değişebilen kısmını (State) oluşturur.
  @override
  State<FirestoreYonetimEkrani> createState() => _FirestoreYonetimEkraniState();
}

// "_" ile başladığı için bu sınıf sadece bu dosyadan erişilebilir (private).
class _FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani> {
  // Ekle / güncelle / sil işlemlerini yapan servis. Ekran Firestore komutlarını
  // doğrudan yazmaz, servise yaptırır; böylece kod daha düzenli olur.
  final FireStoreOgrenciServisi _servis = FireStoreOgrenciServisi();

  // TextEditingController: TextField'a yazılan metni okumak ve temizlemek için.
  final TextEditingController _adsoyadKontrolcusu = TextEditingController();
  final TextEditingController _projeKontrolcusu = TextEditingController();
  final TextEditingController _notKontrolcusu = TextEditingController();

  // dispose: ekran kapanırken çalışır. Controller'lar bellekte yer tuttuğu için
  // burada kapatılır; kapatılmazsa bellek sızıntısı (memory leak) olur.
  @override
  void dispose() {
    _adsoyadKontrolcusu.dispose();
    _projeKontrolcusu.dispose();
    _notKontrolcusu.dispose();
    // Üst sınıfın (State) kendi temizliğini de yapması için en sonda çağrılır.
    super.dispose();
  }

  // build: ekranı çizer. setState çağrıldığında veya stream yeni veri
  // gönderdiğinde ilgili kısım yeniden çalışır.
  @override
  Widget build(BuildContext context) {
    // Scaffold: sayfanın iskeleti (üst bar + gövde).
    return Scaffold(
      // Üstteki başlık çubuğu.
      appBar: AppBar(
        title: const Text("Canlı Firestore ekranı"),
        backgroundColor: Colors.amber.shade600,
      ),
      // Gövde: form, ayırıcı çizgi ve liste alt alta (Column).
      body: Column(
        children: [
          // ---------------- FORM ALANI ----------------
          // Formun kenarlardan 12 piksel boşluklu durması için.
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Ad soyad giriş kutusu; yazılan metin _adsoyadKontrolcusu'nda tutulur.
                TextField(
                  controller: _adsoyadKontrolcusu,
                  decoration: const InputDecoration(
                    labelText: "Öğrenci Adı Soyadı",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                // İki alan arasında 8 piksel dikey boşluk.
                const SizedBox(height: 8),
                // ÖDEV 1: Proje adı ve not yan yana (Row).
                Row(
                  children: [
                    // Expanded: Row'da kalan tüm genişliği proje alanına verir.
                    // Böylece proje adı geniş, not alanı sabit ve dar olur.
                    Expanded(
                      child: TextField(
                        controller: _projeKontrolcusu,
                        decoration: const InputDecoration(
                          labelText: "Proje Adı",
                          prefixIcon: Icon(Icons.work),
                        ),
                      ),
                    ),
                    // Proje ve not alanı arasında 8 piksel yatay boşluk.
                    const SizedBox(width: 8),
                    // Not alanı 90 piksel sabit genişlikte (2-3 haneli sayı için yeterli).
                    SizedBox(
                      width: 90,
                      child: TextField(
                        controller: _notKontrolcusu,
                        // Telefonda harf yerine rakam klavyesi açılır.
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Sayısal Not",
                          prefixIcon: Icon(Icons.grade),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Basınca _yeniOgrenciKaydet çalışır ve öğrenci Firestore'a eklenir.
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.brown,
                    // Butonun yüksekliği 44 piksel, genişliği satırı doldurur.
                    minimumSize: const Size.fromHeight(44),
                  ),
                  onPressed: _yeniOgrenciKaydet,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text("Buluta Kaydet"),
                ),
              ],
            ),
          ),
          // Form ile liste arasında 2 piksel kalınlığında yatay çizgi.
          const Divider(thickness: 2),
          // ---------------- CANLI LİSTE ----------------
          // Expanded: listeye ekranın geri kalan yüksekliğini verir. Column içinde
          // ListView kullanılırken Expanded olmazsa "sınırsız yükseklik" hatası çıkar.
          Expanded(
            // StreamBuilder: bir veri akışını (stream) dinler ve her yeni veride
            // builder'ı tekrar çalıştırır. Firestore'da veri değişince liste anında güncellenir.
            child: StreamBuilder<QuerySnapshot>(
              // 'ogrenciler' koleksiyonu nota göre büyükten küçüğe sıralı dinlenir.
              // .snapshots() tek seferlik .get()'ten farklı olarak sürekli dinleme yapar.
              stream: FirebaseFirestore.instance
                  .collection('ogrenciler')
                  .orderBy('notu', descending: true)
                  .snapshots(),
              // snapshot: akışın o anki durumu (bekleniyor / hata / veri).
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // 1. durum: bağlantı veya izin hatası olursa hata mesajı göster.
                if (snapshot.hasError) {
                  return Center(child: Text("Bulut hatası: ${snapshot.error}"));
                }
                // 2. durum: ilk veri henüz gelmediyse yükleniyor göstergesi.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // 3. durum: veri geldi ama koleksiyon boş.
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Henüz kayıtlı öğrenci yok"));
                }
                // Koleksiyondaki tüm dokümanlar (her biri bir öğrenci).
                final List<DocumentSnapshot> dokumanlar = snapshot.data!.docs;

                // ListView.builder: sadece ekranda görünen satırları oluşturur (performanslı).
                return ListView.builder(
                  itemCount: dokumanlar.length,
                  itemBuilder: (context, index) {
                    final doc = dokumanlar[index];
                    // Firestore dokümanı, modeldeki fromFireStore ile nesneye çevrilir.
                    final ogrenci = OgrenciModel.fromFireStore(doc);
                    // Dismissible: satırı kaydırarak silme özelliği verir.
                    return Dismissible(
                      // Her satırın benzersiz anahtarı; Flutter hangi satırın
                      // silindiğini bununla anlar. Doküman id'si benzersiz olduğu için kullanıldı.
                      key: Key(ogrenci.id),
                      // Sadece sağdan sola kaydırınca silinir.
                      direction: DismissDirection.endToStart,
                      // Kaydırırken arkada görünen kırmızı alan ve çöp kutusu ikonu.
                      background: Container(
                        // İkon sağ tarafta (kaydırmanın başladığı yerde) görünür.
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                      // Kaydırma tamamlanınca: önce Firestore'dan silinir, sonra
                      // alttan bilgi mesajı (SnackBar) çıkar.
                      onDismissed: (direction) {
                        _servis.ogrenciSil(ogrenci.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${ogrenci.adSoyad} kaydı silindi"),
                          ),
                        );
                      },
                      // ListTile: hazır liste satırı (solda ikon, ortada başlık/alt başlık, sağda buton).
                      child: ListTile(
                        // Solda not yazan renkli daire.
                        leading: CircleAvatar(
                          // 80 ve üstü yeşil, 50-79 turuncu, 50 altı kırmızı.
                          backgroundColor: ogrenci.notu >= 80
                              ? Colors.green
                              : (ogrenci.notu >= 50
                                    ? Colors.orange
                                    : Colors.red),
                          child: Text(
                            '${ogrenci.notu}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          ogrenci.adSoyad,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('proje: ${ogrenci.projeAdi}'),
                        // ÖDEV 2: Kalem ikonu not güncelleme penceresini açar.
                        // Mevcut not da gönderilir ki pencere o değerle dolu açılsın.
                        trailing: IconButton(
                          onPressed: () =>
                              _notuGuncelleDialog(ogrenci.id, ogrenci.notu),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Formdaki bilgileri okuyup yeni öğrenciyi Firestore'a ekler.
  // async: Firestore'a yazma internet üzerinden yapıldığı için sonucu bekliyoruz.
  Future<void> _yeniOgrenciKaydet() async {
    // trim(): baştaki ve sondaki boşlukları siler ("  Ali " -> "Ali").
    final adSoyad = _adsoyadKontrolcusu.text.trim();
    final proje = _projeKontrolcusu.text.trim();
    // int.tryParse: metin sayıya çevrilemezse hata vermek yerine null döner.
    final not = int.tryParse(_notKontrolcusu.text.trim());

    // Ad veya proje boşsa uyarı gösterip kaydetmeden çıkılır.
    if (adSoyad.isEmpty || proje.isEmpty) {
      _mesajGoster('Lütfen ad soyad ve proje adını giriniz');
      return;
    }
    // Not sayı değilse veya 0-100 dışındaysa kaydedilmez.
    if (not == null || not < 0 || not > 100) {
      _mesajGoster('Not 0 ile 100 arasında bir sayı olmalıdır');
      return;
    }

    // try/catch: internet yoksa veya Firestore izni yoksa uygulama çökmez,
    // kullanıcıya hata mesajı gösterilir.
    try {
      // Servis 'ogrenciler' koleksiyonuna yeni doküman ekler (id'yi Firestore üretir).
      await _servis.ogrenciEkle(adSoyad: adSoyad, projeAdi: proje, notu: not);
      // Kayıt başarılıysa form temizlenir, yeni öğrenci için hazır olur.
      _adsoyadKontrolcusu.clear();
      _projeKontrolcusu.clear();
      _notKontrolcusu.clear();
      _mesajGoster('$adSoyad buluta kaydedildi');
    } catch (e) {
      _mesajGoster('Kayıt başarısız: $e');
    }
  }

  // ÖDEV 2: Not güncelleme penceresi.
  // Pencere açılır, kullanıcı yeni notu yazar; "Güncelle"ye basarsa not
  // Firestore'da güncellenir. StreamBuilder değişikliği yakaladığı için liste
  // ve sıralama kendiliğinden yenilenir.
  Future<void> _notuGuncelleDialog(String documanId, int mevcutNot) async {
    // showDialog: ekranın ortasında pencere açar ve pencere kapanana kadar bekler.
    // Pencere Navigator.pop(context, deger) ile kapandığında o değer buraya döner.
    final int? yeniNot = await showDialog<int>(
      context: context,
      builder: (context) => NotGuncelleDialog(mevcutNot: mevcutNot),
    );

    // Kullanıcı "İptal"e bastıysa veya pencerenin dışına dokunduysa değer null olur.
    if (yeniNot == null) return;

    try {
      // Servis sadece 'notu' ve 'sonDuzenleme' alanlarını günceller (update).
      await _servis.ogrenciNotuGuncelle(documanId, yeniNot);
      _mesajGoster('Not $yeniNot olarak güncellendi');
    } catch (e) {
      _mesajGoster('Güncelleme başarısız: $e');
    }
  }

  // Ekranın altında kısa bilgi mesajı (SnackBar) gösterir.
  void _mesajGoster(String mesaj) {
    // mounted: await sırasında ekran kapandıysa context artık kullanılamaz,
    // kullanılırsa hata verir. Bu yüzden önce ekranın hâlâ açık olup olmadığına bakılır.
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mesaj)));
  }
}

// Not güncelleme penceresinin kendisi.
// Ayrı bir StatefulWidget yaptık, çünkü pencerenin kendi TextEditingController'ı
// ve hata mesajı var. Controller pencere kapanınca dispose'da güvenle kapatılır.
// Ayrıca Firebase'e bağlı olmadığı için tek başına test edilebiliyor.
class NotGuncelleDialog extends StatefulWidget {
  // Pencere açıldığında kutuda yazılı olacak mevcut not.
  final int mevcutNot;

  const NotGuncelleDialog({super.key, required this.mevcutNot});

  @override
  State<NotGuncelleDialog> createState() => _NotGuncelleDialogState();
}

class _NotGuncelleDialogState extends State<NotGuncelleDialog> {
  // late: değer hemen değil, initState'te verilecek.
  late final TextEditingController _notKontrolcusu;
  // Geçersiz not girilirse kutunun altında gösterilecek hata (null ise hata yok).
  String? _hataMesaji;

  // initState: pencere ilk açıldığında bir kez çalışır.
  // Kutu mevcut notla dolu başlar.
  @override
  void initState() {
    super.initState();
    _notKontrolcusu = TextEditingController(text: '${widget.mevcutNot}');
  }

  @override
  void dispose() {
    _notKontrolcusu.dispose();
    super.dispose();
  }

  // "Güncelle"ye basılınca girilen değeri kontrol eder.
  void _onayla() {
    final yeniNot = int.tryParse(_notKontrolcusu.text.trim());
    if (yeniNot == null || yeniNot < 0 || yeniNot > 100) {
      // setState: hata mesajı değiştiği için pencere yeniden çizilir.
      setState(() => _hataMesaji = '0 ile 100 arasında bir sayı girin');
      return;
    }
    // Pencereyi kapatır ve yeni notu _notuGuncelleDialog'a geri gönderir.
    Navigator.of(context).pop(yeniNot);
  }

  @override
  Widget build(BuildContext context) {
    // AlertDialog: başlık, içerik ve alt butonlardan oluşan hazır pencere.
    return AlertDialog(
      title: const Text('Notu Güncelle'),
      content: TextField(
        controller: _notKontrolcusu,
        keyboardType: TextInputType.number,
        // autofocus: pencere açılınca klavye direkt bu kutuya odaklanır.
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Yeni Not',
          prefixIcon: const Icon(Icons.grade),
          // errorText doluysa kutu kırmızı olur ve altında mesaj yazar.
          errorText: _hataMesaji,
        ),
        // Klavyedeki "tamam" tuşuna basınca da onaylanır.
        onSubmitted: (_) => _onayla(),
      ),
      actions: [
        // İptal: değer göndermeden kapatır (sonuç null döner).
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: _onayla,
          child: const Text('Güncelle'),
        ),
      ],
    );
  }
}
