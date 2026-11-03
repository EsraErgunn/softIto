// =============================================================================
// i_urun_servisi.dart - Ürün servisi sözleşmesi (interface)
// "I" ön eki interface olduğunu belirtir. Ekran sadece bu sözleşmeyi bilir;
// verinin Mock'tan mı, gerçek API'den mi geldiğini bilmez (Dependency Inversion).
// =============================================================================

import '../models/kategori.dart';
import '../models/urun.dart';

abstract class IUrunServisi{
    // Tüm ürünleri döner.
    Future<List<Urun>> tumUrunleriGetir();

    // Sadece verilen kategorideki ürünleri döner (Kategori.hepsi -> tümü).
    Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori);

    // Başlığında arama metni geçen ürünleri döner.
    Future<List<Urun>> adaGoreAra(String aramaMetni);
    
    
}