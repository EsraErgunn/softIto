// =============================================================================
// matches_page.dart - Eşleşmelerim sayfası (Bekleyen / Kabul Edilen / Reddedilen sekmeleri)
// Şimdilik her sekmede boş durum gösterilir; eşleşme verisi henüz bağlanmadı.
// =============================================================================

import 'package:flutter/material.dart';
import '../../../../core/widgets/widgets.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // DefaultTabController: TabBar ve TabBarView'ı ayrı controller yazmadan senkronlar.
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eşleşmelerim'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bekleyen'),
              Tab(text: 'Kabul Edilen'),
              Tab(text: 'Reddedilen'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: EmptyState.matches()),
            Center(child: EmptyState.matches()),
            Center(child: EmptyState.matches()),
          ],
        ),
      ),
    );
  }
}
