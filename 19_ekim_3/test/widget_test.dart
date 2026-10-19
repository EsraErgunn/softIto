import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım App başlangıç duman testi', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();

    expect(find.text('Susadım - Su Takibi'), findsOneWidget);
    expect(find.text('Bugünkü Su Tüketimi'), findsOneWidget);
  });
}
