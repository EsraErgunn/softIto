void main(){
  //Bir bulut kümesinde çalışan servislerin isimlerini içeren bir Set<String> tanımlayın (mükerrer kayıtları elemek için).
  // Ardından bir boolean bool isProduction = true; bayrağı tanımlayın.
  // Eğer ortam prodüksiyon ise listeye "vault-secret-manager" servisini Collection if ile ekleyen 
  //ve tüm servisleri içeren bir List<String> oluşturup ekrana yazdırın.
final Set<String> bulutServisleri = {
  "auth-api",
  "payment-gateway",
  "reporting-worker",
};

  final bool isProduction = true;

  final List<String> tumServisler = [
    ...bulutServisleri, 
    if (isProduction) "vault-secret-manager", 
  ];

  print("Bulut kümesindeki servisler:");
  for (var servis in tumServisler) {
    print(" $servis");
  }
}


