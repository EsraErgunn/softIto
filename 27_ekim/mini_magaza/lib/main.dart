// =============================================================================
// main.dart - Mini Mağaza uygulamasının giriş noktası
// Uygulama burada başlar: tema ayarlanır ve ilk ekran (ürün listesi) açılır.
// =============================================================================

import 'package:flutter/material.dart';
import 'screens/urun_listesi_ekrani.dart';

// runApp: verilen widget'ı ekranın kök (root) widget'ı yapar.
void main() {
  runApp(const MiniMagazaUygulamasi());
}

// Uygulamanın kök widget'ı. Kendi durumu (state) olmadığı için StatelessWidget.
class MiniMagazaUygulamasi extends StatelessWidget {
  const MiniMagazaUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Sağ üstteki kırmızı "DEBUG" şeridini gizler.
      debugShowCheckedModeBanner: false,
      title: "Mini Mağaza",
      theme: ThemeData(
        useMaterial3: true,
        // Tek bir "tohum" renkten (indigo) tüm uyumlu renk paletini Material 3 otomatik üretir.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
      // Uygulama açıldığında gösterilecek ilk ekran.
      home: const UrunListesiEkrani(),
    );
  }
}
