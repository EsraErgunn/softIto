import 'package:flutter/material.dart';
import '../controller/achivement_controller.dart';
import '../widget/badges_grid_view.dart';
import '../widget/pet_rewards_shelf.dart';
import '../widget/points_progress_card.dart';
import '../widget/weekly_tracker_card.dart';

class AchivementView extends StatelessWidget {
  final AchivementController controller;

  const AchivementView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final nextPet = controller.pets.where((p) => !p.isUnlocked).firstOrNull;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WeeklyTrackerCard(days: controller.weeklyDays),
              const SizedBox(height: 20),
              PointsProgressCard(
                points: controller.totalPoints,
                nextPet: nextPet,
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: '🎁 Hediye Hayvan Koleksiyonu', subtitle: 'Puan hedeflerine ulaştıkça açılır'),
              const SizedBox(height: 12),
              PetRewardsShelf(pets: controller.pets),
              const SizedBox(height: 24),
              const _SectionHeader(title: '🎖️ Başarı Rozetleri', subtitle: 'Aktivite tamamlayarak XP kazan'),
              const SizedBox(height: 12),
              BadgesGridView(badges: controller.badges),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(subtitle, style: theme.textTheme.labelSmall),
      ],
    );
  }
}
