//void maim() {
// print("ilk dersimiz - Dart SDK aktif olmalı");
//Jsdeki gibi let x="Ahmet"; x=42; dart bunu kabul etmez.

// 1.Açık belirtilen veri tipleri

// int seansSuresiDakika = 45;
// double seansUcretiTl = 2750.50;
// String uzmanAdi = "Dr Merve Ergün";
// bool aktifMi = true;

// //2.String interpolation
// //js deki `${}` yerine sadece $degisken işlem varsa da ${degisken*2} kullanılır.
// print(
//   "Uzman:$uzmanAdi | süre: $seansSuresiDakika dk | ücret $seansUcretiTl ₺",
// );
// print("KDV dahil (%20) ${seansUcretiTl * 1.20} ₺");

// //3. var ile tip çıkarımı
// var tedaviAdi = "Kahve ile peeling";
// // tedaviAdi =99; hata verir. ilk verdiğin değer olarak tanımlar dart
// print(tedaviAdi);

// //4. dynamic veri tipini bağımısz kullanabilirsiniz ancak flutter da önerilmez
// dynamic serbestKutu = "Lazer Epilasyon";
// serbestKutu = 1000; //izin verilir ama veri tiğ güvenliğini yok eder.

// //const: Derleme anında değeri belli olan veriler, bellekte tek bir yerde saklanır
// const String Klinik_adi = "SoftIto Güzellik Merkezi";
// const double KDV_Orani = 0.20;

// // const DateTime suankiZaman = DateTime.now(); //Hata derleme anında bunu bilemeyiz

// //final: Çalışma anında hesaplanır, bir kere atandıktan sonra değişmez
// final DateTime randevuZamani = DateTime.now();
// final String takipKodu =
//     "SOFT-" + randevuZamani.microsecondsSinceEpoch.toString();

// print("klinik adı: $Klinik_adi");
// print("oluşturulma tarihi: $randevuZamani | kod: $takipKodu");

/*
  //bir değişken varsayılan olarak null olamaz.Bunun yerine null safety operatörleri(?,??,!) kullanırız.
  String zorunluDanisanAdi = "Meltem Demir";
  // zorunluDanisanAdi =null; //hata veriyor
  String? danisanAlerjiNotu;
  print("alerji notu: $danisanAlerjiNotu");

  //ifNull operatörü-null isse varsayılan değer atama
  String goruntulenecekNot =danisanAlerjiNotu ?? "Bilinen bir alerjisi yok";
  print("Rapor: $goruntulenecekNot");

  // null aware
  // print("alerji metin uzunluğu: ${danisanAlerjiNotu.length}"); // bu hata verir bu değer null çünkü
  print("alerji metin uzunluğu: ${danisanAlerjiNotu?.length}");
  */

//klasik sıralı fonksiyon
double topla(double a, double b) => a + b;

//modern dart / Flutter standartlar:Named parameters({})
void seanskaydiOlustur({
  required String danisan,
  required String tedavi,
  required double birimFiyat,
  int seansSayisi = 1, //default değer
  double indirimOrani = 0.0, //default değer
  String? uzmanHekim, //  null olabilir
}) {
  final double brutTutar = birimFiyat * seansSayisi;
  final double indirimTutari = brutTutar * (indirimOrani / 100);
  final double netTutar = brutTutar - indirimTutari;

  print(""" 
===================================
SoftIto Seans Sözleşmesi 

-------------------------

Danişan         : $danisan
Tedavi          : $tedavi (x$seansSayisi Seans)
Uzman Hekim     : ${uzmanHekim ?? "Nöbetçi Estetidyen"}
Brüt Tutar      : $brutTutar ₺
İndirim         : -$indirimTutari ₺ ($indirimOrani)
Ödenecek Tutar  : $netTutar ₺
""");
}
//}

void main() {
  seanskaydiOlustur(
    danisan: "Sümeyye Muhammed",
    tedavi: "Medikal Cilt Yenileme",
    birimFiyat: 4500.0,
    seansSayisi: 3,
    indirimOrani: 15.0,
    uzmanHekim: "Dr.Merve Ergün",
  );
}
