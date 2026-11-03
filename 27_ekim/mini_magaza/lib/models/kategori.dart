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