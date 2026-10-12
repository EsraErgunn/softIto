/*
// Soyutlama Abstraction Kavramı

// 1.adım (sözleşmeler) contract
abstract class AuthReposity{
    Future<String>login(String email, String password);
    Future<void>logouy();
    bool get isAuth;
}

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
class MockAuthReposity implements AutReposity{
   @override
   Future<String> login(String email, String password) async{
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
mixin Logger {
    void log(String msg) => print("LOG:$msg");
}

mixin Analytics{
    void log(String msg) => print("ANALİZ : $msg");
}

    class PaymentService with Logger , Analytics{
        void pay() {
            log("ödeme yapıldı");
        }
    }

// Sadece BaseWidget ve alt sınıflarda kullanılabilir
abstract class BaseWidget {

}
//sadece BaseWidget ve alt sınıflarda kullanılabilir

mixin lifeLogger on BaseWidget {
    void logInit() => print("Widget başlatıldı");
}
*/
/*
extension StringValidator on String {
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

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

abstract class Identifiable {
  String get id;
}

// T tipi Mutlaka Identifiable arayüzünü kullanmak ZORUNDADIR.
class GenericCache<T extends Identifiable> {
  final Map<String, T> _storage = {};

  void save(T item) {
    _storage[item.id] = item;
    print("ID:${item.id} önbelleğe alındıs");
  }

  T? getById(String id) => _storage[id];
}
*/
import 'dart:async';

void main() {
  print("1.Senkron başladı");
  scheduleMicrotask(() {
    print("2.Task Oluştu(Vip Kuyruk)");
  });
  Future(() {
    print("3.Standart Event Kuyruğu");
  });
  Future.microtask(() {
    print("4.Future.microtast çalıştı");
  });

  print("5.Senkron kod tamamlandı");
}
