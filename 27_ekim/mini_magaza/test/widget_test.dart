import 'package:flutter_test/flutter_test.dart';
import 'package:mini_magaza/main.dart';

void main() {
  testWidgets('Mini Mağaza uygulaması açılış testi', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniMagazaUygulamasi());
    await tester.pumpAndSettle();

    expect(find.text('Mini Mağaza'), findsOneWidget);
  });
}
