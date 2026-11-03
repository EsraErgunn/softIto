// =============================================================================
// urun_karti.dart - Listede tek bir ürünü gösteren kart
// Stateless'tır: favori durumunu kendisi tutmaz. Tıklamaları callback'lerle
// (onFavoriTiklandi, onDetayTiklandi) üst ekrana iletir; state ekranda yönetilir.
// =============================================================================

import 'package:flutter/material.dart';

import '../models/urun.dart';
import 'stok_rozeti.dart';

class UrunKarti extends StatelessWidget {
<<<<<<< Updated upstream
    final Urun urun;
    // VoidCallback = parametre almayan, değer döndürmeyen fonksiyon (void Function()).
    final VoidCallback onFavoriTiklandi;
    final VoidCallback onDetayTiklandi;
=======
  final Urun urun;
  final VoidCallback onFavoriTiklandi;
  final VoidCallback onDetayTiklandi;
>>>>>>> Stashed changes

  const UrunKarti({
    super.key,
    required this.urun,
    required this.onFavoriTiklandi,
    required this.onDetayTiklandi,
  });

<<<<<<< Updated upstream
        const UrunKarti({
            super.key,
            required this.urun,
            required this.onFavoriTiklandi,
            required this.onDetayTiklandi,
            
    });
    
    @override
    Widget build(BuildContext context) {
        return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            // InkWell: kartı tıklanabilir yapar ve dokunulduğunda dalga (ripple) efekti verir.
            child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onDetayTiklandi,
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            // Resmin köşelerini yuvarlatmak için kırpar.
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                    urun.resimUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    // Resim inerken spinner gösterilir; progress null ise yükleme bitmiştir.
                                    loadingBuilder: (context, child, progress) {
                                        if (progress == null) return child;
                                        return Container(
                                            width: 90,
                                            height: 90,
                                            color: Colors.grey.shade100,
                                            child: const Center(
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                        );
                                    },
                                    // İnternet yoksa veya URL bozuksa uygulama çökmesin diye yedek ikon gösterilir.
                                    errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                            width: 90,
                                            height: 90,
                                            color: Colors.grey.shade200,
                                            child: const Icon(Icons.broken_image, color: Colors.grey),
                                        );
                                    },
                                ),
                            ),
                            const SizedBox(width: 14),
                            // Expanded: resim ve kalp butonundan kalan tüm genişliği metin sütununa verir.
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text(
                                                    '${urun.kategori.ikon} ${urun.kategori.baslik}',
                                                    style: TextStyle(
                                                        color: Colors.grey.shade600,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                    ),
                                                ),
                                                StokRozeti(stok: urun.stokAdedi),
                                            ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                            urun.baslik,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                            urun.aciklama,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade700,
                                                height: 1.2,
                                            ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                            // toStringAsFixed(2): fiyatı her zaman 2 ondalık basamakla gösterir (1499 -> 1499.00).
                                            '${urun.fiyat.toStringAsFixed(2)} ₺',
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            IconButton(
                                icon: Icon(
                                    // Favoriyse dolu kırmızı kalp, değilse boş gri kalp.
                                    urun.favoriMi ? Icons.favorite : Icons.favorite_border,
                                    color: urun.favoriMi ? Colors.red : Colors.grey,
                                ),
                                onPressed: onFavoriTiklandi,
                            ),
                        ],
                    ),
=======
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onDetayTiklandi,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  urun.resimUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
>>>>>>> Stashed changes
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [StokRozeti(stok: urun.stokAdedi)],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      urun.baslik,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      urun.aciklama,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${urun.fiyat.toStringAsFixed(2)} ₺',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  urun.favoriMi ? Icons.favorite : Icons.favorite_border,
                  color: urun.favoriMi ? Colors.red : Colors.grey,
                ),
                onPressed: onFavoriTiklandi,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
