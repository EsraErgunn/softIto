// =============================================================================
// urun_listesi_ekrani.dart - Ana ekran: ürünleri listeler, arar ve filtreler
// Akış:
//   1) initState -> _urunleriYukle(): servisten tüm ürünler bir kez çekilir (_tumUrunler).
//   2) Arama kutusu veya kategori çipi değişince _filtreyiUygula() çalışır ve
//      _tumUrunler'den süzülen sonuç _filtrelenmisUrunler'e yazılır.
//   3) Ekranda her zaman _filtrelenmisUrunler gösterilir.
// Filtreleme bellekte (client-side) yapıldığı için her tuşta sunucuya gidilmez.
// =============================================================================

import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/kategori.dart';
import '../services/mock_urun_servisi.dart';
import '../services/i_urun_servisi.dart';
import '../widgets/urun_karti.dart';

// Arama metni, seçili kategori ve favoriler değiştiği için StatefulWidget.
class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  // Tip arayüz (IUrunServisi), nesne Mock. İleride gerçek API servisi yazılınca
  // sadece bu satır değişir, ekranın geri kalanı aynen çalışır.
  final IUrunServisi _servis = MockUrunServisi();

  // Arama kutusundaki metni okumak ve temizlemek için kullanılır.
  final TextEditingController _aramaController = TextEditingController();

  // Servisten gelen ham liste (filtrelenmemiş, asıl kaynak).
  List<Urun> _tumUrunler = [];
  // Arama + kategori filtresinden geçip ekranda gösterilen liste.
  List<Urun> _filtrelenmisUrunler = [];
  // true iken ekranda yükleniyor animasyonu gösterilir.
  bool _yukleniyorMu = true;
  Kategori _seciliKategori = Kategori.hepsi; // başlangıç değeri bu. başlangıçta hepsi seçili.

  @override
  // Ekran ilk oluşturulduğunda bir kez çalışır; veri yükleme için doğru yer.
  void initState() {
    super.initState();
    _urunleriYukle();
  }

  // önce başlaması lazım yukarıda initState ile başlattık
  // ekran kapanınca controller dispose edilmeli
  @override
  void dispose() {
    _aramaController.dispose();
    super.dispose();
  }

  // çok fazla ürün olursa pagination yaparsın, her sayfada tekrar arama yapar kullanıcı.

  // Servisten ürünleri asenkron olarak çeker.
  Future<void> _urunleriYukle() async {
    setState(() {
      _yukleniyorMu = true;
    });

    //final urunler = await _servis.kategoriyeGoreGetir(_seciliKategori);
    final urunler = await _servis.tumUrunleriGetir();

    // await sırasında kullanıcı ekrandan çıkmış olabilir. Ekran artık yoksa
    // setState çağırmak hata verir, bu yüzden önce "mounted" kontrol edilir.
    if (mounted) {
      setState(() {
        _tumUrunler = urunler;
        _yukleniyorMu = false;
      });
      _filtreyiUygula(); // ilk açılışta liste dolsun diye
    }
  }

  // Kategori VE arama koşulunu birlikte uygular; ikisini de sağlayan ürünler kalır.
  void _filtreyiUygula() {
    // Büyük/küçük harf duyarsız arama için hem aranan hem ürün metni küçük harfe çevrilir.
    final aranan = _aramaController.text.trim().toLowerCase();

    setState(() {
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        final kategoriUygunMu = (_seciliKategori == Kategori.hepsi) ||
            (urun.kategori == _seciliKategori);
        final aramaUygunMu = aranan.isEmpty ||
            urun.baslik.toLowerCase().contains(aranan) ||
            urun.aciklama.toLowerCase().contains(aranan);

        return kategoriUygunMu && aramaUygunMu;
      }).toList();
    });
  }

  // Model immutable olduğu için ürün doğrudan değiştirilmez; copyWith ile yeni
  // nesne oluşturulup listedeki eski nesnenin yerine konur.
  void _favoriyiDegistir(Urun hedefUrun) {
    // id değişmiyor, sadece favoriMi tersine döner.
    final yeniUrun = hedefUrun.copyWith(favoriMi: !hedefUrun.favoriMi);
    final index = _tumUrunler.indexWhere((u) => u.id == hedefUrun.id);

    if (index != -1) {
      // indexWhere bulamazsa -1 döner
      _tumUrunler[index] = yeniUrun;
    }
    _filtreyiUygula(); // içinde setState var, ekranı o yeniler
  }

  @override
  // setState her çağrıldığında build yeniden çalışır ve ekran güncellenir.
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mini Mağaza",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              // AppBar'daki kalp ikonunun üzerinde favori ürün sayısını gösterir.
              child: Badge(
                label: Text(
                  '${_tumUrunler.where((u) => u.favoriMi).length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                child: const Icon(Icons.favorite, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ARAMA KUTUSU
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _aramaController,
              // Her tuş vuruşunda liste anında filtrelenir (canlı arama).
              onChanged: (_) => _filtreyiUygula(),
              decoration: InputDecoration(
                hintText: "Ürün veya marka ara...",
                prefixIcon: const Icon(Icons.search),
                // Kutu doluysa sağda "temizle" (X) butonu çıkar, boşsa hiçbir şey gösterilmez.
                suffixIcon: _aramaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _aramaController.clear();
                          _filtreyiUygula();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // KATEGORİ ÇİPLERİ
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              // Enum'daki her kategori için bir ChoiceChip üretilir; yeni kategori eklenince
              // çip otomatik oluşur.
              children: Kategori.values.map((kategori) {
                final seciliMi = _seciliKategori == kategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    avatar: Text(kategori.ikon),
                    label: Text(kategori.baslik),
                    selected: seciliMi,
                    onSelected: (secildi) {
                      if (secildi) {
                        _seciliKategori = kategori;
                        _filtreyiUygula();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // ÜRÜN LİSTESİ
          Expanded(
            // Üç durum: yükleniyor -> spinner, sonuç yok -> boş durum mesajı, aksi halde liste.
            child: _yukleniyorMu
                ? const Center(child: CircularProgressIndicator())
                : _filtrelenmisUrunler.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Aradığınız kriterlere uygun ürün bulunamadı.',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    // ListView.builder sadece ekranda görünen kartları oluşturur (performanslı).
                    : ListView.builder(
                        itemCount: _filtrelenmisUrunler.length,
                        itemBuilder: (context, index) {
                          final urun = _filtrelenmisUrunler[index];
                          return UrunKarti(
                            urun: urun,
                            // Kart kendi durumunu tutmaz; tıklama olayını callback ile ekrana bildirir.
                            onFavoriTiklandi: () => _favoriyiDegistir(urun),
                            onDetayTiklandi: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${urun.baslik} TIKLANDI!'),
                                  duration: const Duration(milliseconds: 600),
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
}