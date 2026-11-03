// =============================================================================
// widget_test.dart - Uygulama açılış (duman) testi
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:girisim_destek/app/app.dart';
import 'package:girisim_destek/core/storage/prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Testte gerçek cihaz deposu yok; boş bir sahte depo kullanılır.
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // main.dart'taki gibi prefs enjekte edilir; yoksa prefsProvider hata fırlatır.
          prefsProvider.overrideWithValue(prefs),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();
    // Oturum olmadığı için router karşılama sayfasına yönlendirir; başlık orada görünmeli.
    expect(find.text('Girişim Destek Platformu'), findsOneWidget);
  });
}
