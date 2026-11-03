// =============================================================================
// sozlesme.dart - OOP kavramları ve Event Loop örnekleri
// -----------------------------------------------------------------------------
// Bu dosyada derste işlenen konular yorum bloğu (/* */) içinde saklanıyor:
//   1) Abstraction (Soyutlama) / Contract: abstract class ile "sözleşme" yazıp
//      farklı sınıflarla (Firebase, Mock) uygulamak.
//   2) Mixin: birden fazla sınıfa ortak davranış eklemek ("with" anahtar kelimesi).
//   3) Extension: var olan bir tipe (String) yeni metot/getter eklemek.
//   4) Generic + Bound: <T extends Identifiable> ile tip kısıtlamak.
// En alttaki aktif main() ise microtask / event kuyruğu sırasını gösterir.
//
// NOT: Yorum içindeki kodlarda yazım hataları var (AuthReposity, autRepository,
// logouy, ";" eksikliği). Yorumdan çıkarılırsa önce bunlar düzeltilmeli.
// =============================================================================

/*
// Soyutlama Abstraction Kavramı
// Amaç: UI katmanı "hangi servis" olduğunu bilmez, sadece sözleşmeyi (arayüzü) bilir.
// Böylece Firebase yerine Mock ya da başka bir servis koda dokunmadan takılabilir.

// 1.adım (sözleşmeler) contract
// abstract class gövdesiz metotlar içerir; implements eden sınıf hepsini yazmak ZORUNDADIR.
abstract class AuthReposity{
    Future<String>login(String email, String password);
    Future<void>logouy();
    bool get isAuth;
}

// 2.adım: Sözleşmenin gerçek (production) uygulaması.
class FirebaseAuthRepository implements autRepository
 {
    @override
    Future<String> login(String email, String password) async{
        //gerçek Firebase SDK Çaprısı
        return "firebase_token_xyz_123;"
    }

    @override
    Future<void> logout() async{
        // Firebase logout
    }

    @override
    bool get isAuth => true;
}

//  Test ve offline simülasyon
// 3.adım: Aynı sözleşmenin sahte (mock) uygulaması. İnternet/Firebase olmadan
// test yazmak veya arayüzü geliştirmek için kullanılır.
class MockAuthReposity implements AutReposity{
   @override
   Future<String> login(String email, String password) async{
    // Ağ gecikmesini taklit etmek için 1 saniye beklenir.
    await Future.delayed(Duration(seconds:1));
    return "mock_token_abc_789";
   } 
   @override
   Future<void> logout() async {}

   @override
   bool get isAuth => false;
}
*/
/*
// MIXIN: Kalıtım (extends) olmadan sınıflara hazır metot eklemenin yolu.
// Bir sınıf tek bir sınıftan extends edebilir ama birden çok mixin kullanabilir.
mixin Logger {
    void log(String msg) => print("LOG:$msg");
}

mixin Analytics{
    void log(String msg) => print("ANALİZ : $msg");
}

    // DİKKAT: İki mixin'de de log() var. Çakışmada "en sağdaki" kazanır,
    // yani burada Analytics.log çalışır ve çıktı "ANALİZ : ödeme yapıldı" olur.
    class PaymentService with Logger , Analytics{
        void pay() {
            log("ödeme yapıldı");
        }
    }

// Sadece BaseWidget ve alt sınıflarda kullanılabilir
abstract class BaseWidget {

}
//sadece BaseWidget ve alt sınıflarda kullanılabilir
// "on BaseWidget" kısıtı: bu mixin yalnızca BaseWidget'tan türeyen sınıflara eklenebilir.

mixin lifeLogger on BaseWidget {
    void logInit() => print("Widget başlatıldı");
}
*/
/*
// EXTENSION: String sınıfının kaynak koduna dokunmadan ona yeni yetenek ekler.
// Artık her String üzerinde "metin".isValidEmail ve "metin".toCapitalize() kullanılabilir.
extension StringValidator on String {
  // Regex ile e-posta formatını kontrol eder (kullanici@alan.uzanti).
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  // İlk harfi büyütür: "esra" -> "Esra". Extension içinde "this" String'in kendisidir.
  String toCapitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

//Kullanımı
void main() {
  String email = "selahaddin@kodvance.com";
  if (email.isValidEmail) {
    print("Geçerli email");
  } else {
    print("Geçersiz email");
  }
}

// GENERIC KISITLAMA: id'si olan her nesne bu arayüzü uygular.
abstract class Identifiable {
  String get id;
}

// T tipi Mutlaka Identifiable arayüzünü kullanmak ZORUNDADIR.
// Tek bir sınıf yazıp her tür (User, Product...) için önbellek olarak kullanılabilir.
// "extends Identifiable" sayesinde item.id'ye güvenle erişilir.
class GenericCache<T extends Identifiable> {
  // id -> nesne eşlemesi; başındaki "_" alanı dosyaya özel (private) yapar.
  final Map<String, T> _storage = {};

  void save(T item) {
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındıs");
  }

  // Bulamazsa null döner, bu yüzden dönüş tipi T? (nullable).
  T? getById(String id) => _storage[id];
}
*/

// -----------------------------------------------------------------------------
// AKTİF KOD: Event Loop sırası
// Çıktı: 1 -> 5 (senkron) -> 2 -> 4 (microtask) -> 3 (event)
// -----------------------------------------------------------------------------
import 'dart:async';

void main() {
  // Senkron kod: hemen çalışır.
  print("1.Senkron başladı");
  // Microtask (VIP kuyruk): senkron kod biter bitmez, event'lerden önce çalışır.
  scheduleMicrotask(() {
    print("2.Task Oluştu(Vip Kuyruk)");
  });
  // Event Queue: tüm microtask'lar bittikten sonra çalışır, bu yüzden en son yazdırılır.
  Future(() {
    print("3.Standart Event Kuyruğu");
  });
  // Future.microtask da microtask kuyruğuna girer; kodda sonra yazılsa da 3'ten önce çalışır.
  Future.microtask(() {
    print("4.Future.microtast çalıştı");
  });

  // Senkron kod: 1'den hemen sonra çalışır.
  print("5.Senkron kod tamamlandı");
}
