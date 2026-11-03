// =============================================================================
// urun.dart - Ürün veri modeli
// Tüm alanlar final, yani nesne oluşturulduktan sonra değiştirilemez (immutable).
// Değişiklik gerektiğinde copyWith ile yeni bir kopya üretilir.
// =============================================================================

import 'kategori.dart';
import 'degerlendirme.dart';

class Urun {
  final int id;
  final String baslik;
  final String aciklama;
  final double fiyat;
  final String resimUrl;
  final Kategori kategori;
  final int stokAdedi;
  final bool favoriMi;
  final Degerlendirme degerlendirme;

<<<<<<< Updated upstream
    const Urun({
        required this.id,
        required this.baslik,
        required this.aciklama,
        required this.fiyat,
        required this.resimUrl,
        required this.kategori,
        required this.stokAdedi,
        // Opsiyonel parametre: verilmezse ürün favori değildir.
        this.favoriMi = false,
    });

    // copyWith: Sadece verilen alanları değiştirip geri kalanını aynen kopyalayan yeni Urun döner.
    // Örnek: urun.copyWith(favoriMi: true) -> diğer her şey aynı, sadece favori değişti.
    Urun copyWith({
        int? id,
        String? baslik,
        String? aciklama,
        double? fiyat,
        String? resimUrl,
        Kategori? kategori,
        int? stokAdedi,
        bool? favoriMi,   
    }){
        return Urun(
            // "??" operatörü: soldaki null ise sağdakini kullan (yeni değer yoksa eskisini koru).
            id: id?? this.id,
            baslik:baslik?? this.baslik,
            aciklama: aciklama?? this.aciklama,
            fiyat: fiyat?? this.fiyat,
            resimUrl: resimUrl?? this.resimUrl,
            kategori: kategori?? this.kategori,
            stokAdedi: stokAdedi?? this.stokAdedi,
            favoriMi: favoriMi?? this.favoriMi,
        );
    }

    @override
    // print(urun) yazıldığında okunabilir bir çıktı vermesi için override edildi.
    String toString(){
        return "Urun(id: $id,baslik: $baslik, fiyat: $fiyat, favoriMi: $favoriMi)";
        
    }
=======
  const Urun({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.fiyat,
    required this.resimUrl,
    required this.kategori,
    required this.stokAdedi,
    required this.degerlendirme,
    this.favoriMi = false,
  });

  factory Urun.fromJson(Map<String, dynamic> json) {
    final ratingMap = json['rating'] as Map<String, dynamic>? ?? {};

    return Urun(
      id: (json['id'] as num?)?.toInt() ?? 0,
      baslik: json['title'] as String? ?? '',
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      aciklama: json['description'] as String? ?? '',
      kategori: KategoriExtension.apiMetindenUret(
        json['category'] as String? ?? '',
      ),
      resimUrl: json['image'] as String? ?? '',
      stokAdedi: (ratingMap['count'] as num?)?.toInt() ?? 0,
      degerlendirme: Degerlendirme.fromJson(ratingMap),
      favoriMi: false,
    );
  }
>>>>>>> Stashed changes

  Urun copyWith({
    int? id,
    String? baslik,
    String? aciklama,
    double? fiyat,
    String? resimUrl,
    Kategori? kategori,
    int? stokAdedi,
    Degerlendirme? degerlendirme,
    bool? favoriMi,
  }) {
    return Urun(
      id: id ?? this.id,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      fiyat: fiyat ?? this.fiyat,
      resimUrl: resimUrl ?? this.resimUrl,
      kategori: kategori ?? this.kategori,
      stokAdedi: stokAdedi ?? this.stokAdedi,
      degerlendirme: degerlendirme ?? this.degerlendirme,
      favoriMi: favoriMi ?? this.favoriMi,
    );
  }

  @override
  String toString() {
    return "Urun(id: $id,baslik: $baslik, fiyat: $fiyat, favoriMi: $favoriMi)";
  }
}
