// =============================================================================
// achievement_view.dart - Rozetler & ödüller sekmesi
// Bu sürümde her View kendi controller'ını oluşturur ve kapanırken dispose eder.
// =============================================================================

import 'package:flutter/material.dart';
import '../controller/achievement_controller.dart';
import '../models/achievement_model.dart';
import '../widget/achievement_card.dart';

class AchievementView extends StatefulWidget {
  const AchievementView({super.key});

  @override
  State<AchievementView> createState() => _AchievementViewState();
}

class _AchievementViewState extends State<AchievementView> {
  late final AchievementController _controller;

  @override
  void initState() {
    super.initState();
    // Controller ekranın ömrü boyunca bir kez oluşturulur (late final).
    _controller = AchievementController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    // Model değişince (puan ekleme/sıfırlama) liste yeni "data" ile yeniden çizilir.
    return ValueListenableBuilder<AchievementModel>(
      valueListenable: _controller.state,
      builder: (context, data, _) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            AchievementCard(data: data),
            const SizedBox(height: 16),
            FilledButton.icon(
              // Demo butonu: her basışta 50 puan ekler (rozet/hayvan eşiklerini denemek için).
              onPressed: () => _controller.addPoints(50),
              icon: const Icon(Icons.card_giftcard),
              label: const Text('+50 Haftalık Puan Kazan'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _controller.reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Puanları Sıfırla'),
            ),
          ],
        );
      },
    );
  }
}
