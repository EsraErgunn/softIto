import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('SusadimApp başlatma, su ekleme ve ödüller sekmesi testi', (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    // Başlık ve sekmelerin varlığını doğrula
    expect(find.text('💧 Susadım - Su Takibi'), findsOneWidget);
    expect(find.text('Su Takibi'), findsOneWidget);
    expect(find.text('Egzersiz'), findsOneWidget);
    expect(find.text('Ödüller'), findsOneWidget);

    // Başlangıçta 0 ml su tüketimi
    expect(find.text('0'), findsOneWidget);

    // +250 ml Kupa butonuna tıkla
    await tester.tap(find.text('+250'));
    await tester.pumpAndSettle();

    // Değerin 250 ml olarak güncellendiğini doğrula
    expect(find.text('250'), findsOneWidget);

    // Ödüller sekmesine geç
    await tester.tap(find.text('Ödüller'));
    await tester.pumpAndSettle();

    // Ödüller sayfasındaki haftalık takip ve hediye hayvan başlığını doğrula
    expect(find.text('Haftalık Takip'), findsOneWidget);
    expect(find.text('🎁 Hediye Hayvan Koleksiyonu'), findsOneWidget);
    expect(find.text('Siber Kurt'), findsOneWidget);
  });
}
