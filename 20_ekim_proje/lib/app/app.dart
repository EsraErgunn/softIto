// =============================================================================
// app.dart - Kök uygulama widget'ı (tema + router bağlantısı)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'theme/theme_mode_provider.dart';

// ConsumerWidget: build metoduna "ref" verir; ref ile provider'lar okunur/izlenir.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch: provider'ı izler; değeri değişirse bu widget yeniden çizilir.
    final router = ref.watch(routerProvider);
    // Ayarlardan tema değişince burası tetiklenir ve tüm uygulama yeni temaya geçer.
    final themeMode = ref.watch(themeModeProvider);

    // .router: sayfa geçişlerini Navigator yerine GoRouter yönetir.
    return MaterialApp.router(
      title: 'Girişim Destek Platformu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
