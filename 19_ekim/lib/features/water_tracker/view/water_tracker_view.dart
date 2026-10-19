import 'package:flutter/material.dart';
import '../controller/water_controller.dart';
import '../widget/water_history_list.dart';
import '../widget/water_progress_ring.dart';
import '../widget/water_quick_add_buttons.dart';
import '../widget/water_stats_row.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterController controller;

  const WaterTrackerView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WaterProgressRing(
                currentMl: controller.currentAmountMl,
                goalMl: controller.dailyGoalMl,
                progress: controller.progress,
              ),
              const SizedBox(height: 24),
              WaterStatsRow(
                remainingMl: controller.remainingMl,
                dailyGoalMl: controller.dailyGoalMl,
                isGoalReached: controller.isGoalReached,
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Hızlı Ekle'),
              const SizedBox(height: 12),
              WaterQuickAddButtons(onAdd: controller.addIntake),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Bugünkü Kayıtlar'),
              const SizedBox(height: 12),
              WaterHistoryList(
                intakes: controller.intakes,
                onDelete: controller.removeIntake,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(title, style: theme.textTheme.titleMedium);
  }
}
