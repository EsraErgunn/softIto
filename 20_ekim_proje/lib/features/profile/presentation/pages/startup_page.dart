// =============================================================================
// startup_page.dart - "Girişimim" sayfası
// İş planı olup olmamasına göre farklı sekmeler gösterilir (bkz. app/tab_config.dart).
// Sekme içerikleri şimdilik sadece başlık gösteriyor.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/tab_config.dart';
import '../../../../core/session/session_provider.dart';

class StartupPage extends ConsumerWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final hasBusinessPlan = session.user?.hasBusinessPlan ?? false;
    // Oturumdaki iş planı bilgisine göre sekme listesi üretilir.
    final tabs = startupTabsFor(hasBusinessPlan: hasBusinessPlan);

    return DefaultTabController(
      // Sekme sayısı dinamik olduğu için controller uzunluğu listeden alınır.
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Girişimim'),
          bottom: TabBar(
            tabs: tabs.map((t) => Tab(icon: Icon(t.icon), text: t.label)).toList(),
          ),
        ),
        body: TabBarView(
          children: tabs.map((t) => Center(child: Text(t.label))).toList(),
        ),
      ),
    );
  }
}
