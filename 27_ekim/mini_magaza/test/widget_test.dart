// =============================================================================
// widget_test.dart - Uygulamanın açılış (smoke) testi
// Uygulama hatasız açılıyor ve başlık görünüyor mu kontrol eder.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_magaza/main.dart';

void main() {
  testWidgets('Mini Mağaza uygulaması açılış testi', (WidgetTester tester) async {
    // Uygulamayı sanal bir test ekranına çizer.
    await tester.pumpWidget(const MiniMagazaUygulamasi());
    // Tüm animasyonlar ve bekleyen Future'lar (1,5 sn mock gecikmesi) bitene kadar bekler.
    await tester.pumpAndSettle();

    // AppBar başlığının ekranda tam olarak 1 kez bulunduğunu doğrular.
    expect(find.text('Mini Mağaza'), findsOneWidget);
  });
}
