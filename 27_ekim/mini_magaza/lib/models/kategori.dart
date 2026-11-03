<<<<<<< Updated upstream
// =============================================================================
// kategori.dart - Ürün kategorileri
// Gelişmiş (enhanced) enum: her kategori sabitinin kendi alanları (baslik, ikon) var.
// Kategori çiplerinde (ChoiceChip) Kategori.values ile hepsi döngüyle listelenir.
// =============================================================================

enum Kategori {
  // "hepsi" gerçek bir kategori değil; filtreleme yapılmayacağını belirten özel değer.
  hepsi('Tümü', 'H'),
  elektronik('Elektronik', 'E'),
  giyim('Giyim', 'G'),
  ayakkabi('Ayakkabı', 'A'),
  aksesuar('Aksesuar', 'AK');

  // Ekranda görünen ad.
  final String baslik;
  // Çipte avatar olarak gösterilen kısaltma.
  final String ikon;

  // Enum constructor'ı her zaman const olmak zorundadır.
  const Kategori(this.baslik, this.ikon);
}
=======
enum Kategori { hepsi, elektronik, taki, erkekGiyim, kadinGiyim }

extension KategoriExtension on Kategori {
  String get gorunenAd {
    switch (this) {
      case Kategori.hepsi:
        return "Tümü";
      case Kategori.elektronik:
        return "Elektronik";
      case Kategori.taki:
        return "Taki & mücevher";
      case Kategori.erkekGiyim:
        return "Erkek Giyim";
      case Kategori.kadinGiyim:
        return "Kadın Giyim";
    }
  }

  static Kategori apiMetindenUret(String apiMetni) {
    switch (apiMetni.toLowerCase().trim()) {
      case "electronics":
        return Kategori.elektronik;
      case "jewelery":
        return Kategori.taki;
      case "men's clothing":
        return Kategori.erkekGiyim;
      case "women's clothing":
        return Kategori.kadinGiyim;
      default:
        return Kategori.hepsi;
    }
  }
}
>>>>>>> Stashed changes
