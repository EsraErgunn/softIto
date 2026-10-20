import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:girisim_destek/app/app.dart';
import 'package:girisim_destek/core/storage/prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          prefsProvider.overrideWithValue(prefs),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Girişim Destek Platformu'), findsOneWidget);
  });
}
