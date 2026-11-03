// =============================================================================
// main.dart - "Susadım" uygulamasının giriş noktası
// Su takibi, antrenman takibi ve başarım (rozet/evcil hayvan) özelliklerini içeren
// fitness uygulaması. Proje "feature-first" klasörlenmiştir:
//   core/      -> tüm uygulamada ortak renkler ve tema
//   features/  -> her özellik kendi model / controller / view / widget klasörüyle
// =============================================================================

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/view/home_view.dart';

void main() {
  // Flutter motorunu runApp'ten önce hazırlar (plugin veya async başlatma yapılacaksa şarttır).
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

// Kök widget: tema ve ilk ekranı (HomeView) belirler.
class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      // Tüm renk/yazı ayarları tek yerden (AppTheme) gelir.
      theme: AppTheme.darkTheme,
      home: const HomeView(),
    );
  }
}
