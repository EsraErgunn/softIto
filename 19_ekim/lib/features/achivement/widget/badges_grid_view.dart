import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/achievement_badge.dart';

class BadgesGridView extends StatelessWidget {
  final List<AchievementBadge> badges;

  const BadgesGridView({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: badges.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _BadgeTile(badge: badge);
      },
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final AchievementBadge badge;
  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = badge.isUnlocked;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked ? AppColors.neonAmber.withValues(alpha: 0.5) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isUnlocked ? AppColors.neonAmber.withValues(alpha: 0.15) : AppColors.surfaceElevated,
            child: Icon(
              badge.icon,
              color: isUnlocked ? AppColors.neonAmber : AppColors.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(badge.title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text(badge.description, style: theme.textTheme.labelSmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isUnlocked ? AppColors.neonAmber.withValues(alpha: 0.15) : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '+${badge.pointsReward} XP',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isUnlocked ? AppColors.neonAmber : AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
