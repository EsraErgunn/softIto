import 'package:flutter/material.dart';
import '../models/achievement_model.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel data;

  const AchievementCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    final theme = Theme.of(context);
    final hasPet = data.awardedPet != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Haftalık Takip & Rozetler', style: theme.textTheme.titleMedium),
                Icon(Icons.emoji_events, color: theme.colorScheme.tertiary),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: data.scoreRatio,
              color: theme.colorScheme.tertiary,
              minHeight: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 12),
            Text('${data.totalScore} / ${data.targetScoreForPet} Puan'),
            const SizedBox(height: 14),
            _PetRewardBanner(hasPet: hasPet, petName: data.awardedPet),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: data.unlockedBadges
                  .map((badge) => Chip(
                        avatar: const Icon(Icons.star, size: 16),
                        label: Text(badge),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetRewardBanner extends StatelessWidget {
  final bool hasPet;
  final String? petName;

  const _PetRewardBanner({
    required this.hasPet,
    this.petName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(hasPet ? Icons.pets : Icons.lock, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hasPet
                  ? 'Kazanılan Hediye Hayvan: $petName 🦦'
                  : '500 puanda "Akıllı Su Samuru" hediye edilecek!',
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
