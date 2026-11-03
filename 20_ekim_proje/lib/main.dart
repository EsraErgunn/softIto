// =============================================================================
// main.dart - "Girişim Destek Platformu" uygulamasının giriş noktası
// Girişimcileri mentör, yatırımcı, destek programları ve toplulukla buluşturan uygulama.
// Kullanılan temel paketler:
//   - flutter_riverpod   -> state yönetimi ve bağımlılık enjeksiyonu (Provider'lar)
//   - go_router          -> sayfa yönlendirme (URL tabanlı rotalar, giriş kontrolü)
//   - shared_preferences -> küçük verileri cihazda kalıcı saklama (tema, oturum)
//   - freezed / json_serializable -> immutable modeller ve JSON dönüşümü (kod üretimi)
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'core/storage/prefs_provider.dart';

// main async: uygulama açılmadan önce SharedPreferences yüklenmesi beklenir.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Cihaz deposu bir kez açılır; sonra her yerde senkron olarak kullanılabilir.
  final prefs = await SharedPreferences.getInstance();

  runApp(
    // ProviderScope: Riverpod'un tüm provider'larını tutan kök widget; en tepede olmalı.
    ProviderScope(
      overrides: [
        // prefsProvider tanımında gerçek değer yoktur; burada yüklenen prefs nesnesi
        // "override" ile enjekte edilir. Testlerde sahte bir değer de verilebilir.
        prefsProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}
