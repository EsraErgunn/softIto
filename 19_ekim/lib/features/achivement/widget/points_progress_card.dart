import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/pet_reward.dart';

class PointsProgressCard extends StatelessWidget {
  final int points;
  final PetReward? nextPet;

  const PointsProgressCard({
    super.key,
    required this.points,
    required this.nextPet,
  });

  @override
  Widget build(BuildContext context) {
    final nextTarget = nextPet?.requiredPoints ?? 1000;
    final progress = (points / nextTarget).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PointsHeader(points: points),
          const SizedBox(height: 14),
          _ProgressBar(progress: progress),
          const SizedBox(height: 10),
          _NextPetInfo(nextPet: nextPet, points: points),
        ],
      ),
    );
  }
}

class _PointsHeader extends StatelessWidget {
  final int points;
  const _PointsHeader({required this.points});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.stars_rounded, color: AppColors.neonAmber, size: 24),
            const SizedBox(width: 8),
            Text('Toplam Puan (XP)', style: theme.textTheme.titleMedium),
          ],
        ),
        Text(
          '$points XP',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.neonAmber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: AppColors.surfaceElevated,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonAmber),
      ),
    );
  }
}

class _NextPetInfo extends StatelessWidget {
  final PetReward? nextPet;
  final int points;

  const _NextPetInfo({required this.nextPet, required this.points});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (nextPet == null) {
      return Text('Tüm hayvan ödülleri açıldı! Efsanesin! 🎉', style: theme.textTheme.labelSmall);
    }

    final diff = nextPet!.requiredPoints - points;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sıradaki: ${nextPet!.emoji} ${nextPet!.name}',
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          diff > 0 ? '$diff XP kaldı' : 'Açılmaya hazır!',
          style: theme.textTheme.labelSmall?.copyWith(color: AppColors.neonCyan),
        ),
      ],
    );
  }
}
