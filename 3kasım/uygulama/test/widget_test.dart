import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uygulama/firestore_yonetim_ekrani.dart';

void main() {
  Future<void> pencereyiAc(WidgetTester tester, {required int mevcutNot}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog<int>(
              context: context,
              builder: (_) => NotGuncelleDialog(mevcutNot: mevcutNot),
            ),
            child: const Text('Aç'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Aç'));
    await tester.pumpAndSettle();
  }

  testWidgets('Not güncelleme penceresi mevcut notla açılır', (tester) async {
    await pencereyiAc(tester, mevcutNot: 75);
    expect(find.text('Notu Güncelle'), findsOneWidget);
    expect(find.text('75'), findsOneWidget);
  });

  testWidgets('Geçersiz not girilince hata gösterilir, pencere kapanmaz', (tester) async {
    await pencereyiAc(tester, mevcutNot: 75);
    await tester.enterText(find.byType(TextField), '150');
    await tester.tap(find.text('Güncelle'));
    await tester.pumpAndSettle();
    expect(find.text('0 ile 100 arasında bir sayı girin'), findsOneWidget);
    expect(find.text('Notu Güncelle'), findsOneWidget);
  });

  testWidgets('Geçerli not girilince pencere kapanır ve not döner', (tester) async {
    int? donenNot;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              donenNot = await showDialog<int>(
                context: context,
                builder: (_) => const NotGuncelleDialog(mevcutNot: 40),
              );
            },
            child: const Text('Aç'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Aç'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '90');
    await tester.tap(find.text('Güncelle'));
    await tester.pumpAndSettle();
    expect(find.text('Notu Güncelle'), findsNothing);
    expect(donenNot, 90);
  });
}
