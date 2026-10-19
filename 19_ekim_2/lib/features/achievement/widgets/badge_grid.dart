import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/achievement_model.dart';

/// Rozetlerin listelendiği bileşen - Tema duyarlı
class BadgeGrid extends StatelessWidget {
  final List<BadgeItem> badges;

  const BadgeGrid({
    super.key,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? AppColors.surfaceCard;
    final borderColor = theme.dividerTheme.color ?? AppColors.surfaceBorder;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          ...badges.map((b) => _buildBadgeRow(context, b)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Row(
      children: [
        const Icon(Icons.workspace_premium_rounded,
            color: AppColors.neonAmber, size: 20),
        const SizedBox(width: 8),
        Text(
          'Kazanılan Rozetler',
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeRow(BuildContext context, BadgeItem badge) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rowBg = isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final rowBorder = isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: badge.isUnlocked
              ? AppColors.neonAmber.withAlpha(80)
              : rowBorder,
        ),
      ),
      child: Row(
        children: [
          _buildBadgeIcon(context, badge),
          const SizedBox(width: 12),
          _buildBadgeTexts(context, badge),
          _buildPointsReward(badge),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(BuildContext context, BadgeItem badge) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBg = isDark ? AppColors.surfaceCard : AppColors.lightSurfaceCard;
    final border = isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder;

    IconData icon;
    switch (badge.iconName) {
      case 'water':
        icon = Icons.water_drop_rounded;
        break;
      case 'fire':
        icon = Icons.local_fire_department_rounded;
        break;
      case 'shield':
        icon = Icons.verified_user_rounded;
        break;
      default:
        icon = Icons.emoji_events_rounded;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: badge.isUnlocked
            ? AppColors.neonAmber.withAlpha(40)
            : iconBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: badge.isUnlocked ? AppColors.neonAmber : border,
        ),
      ),
      child: Icon(
        icon,
        color: badge.isUnlocked ? AppColors.neonAmber : AppColors.textMuted,
        size: 22,
      ),
    );
  }

  Widget _buildBadgeTexts(BuildContext context, BadgeItem badge) {
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            badge.title,
            style: TextStyle(
              color: badge.isUnlocked
                  ? titleColor
                  : AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            badge.description,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsReward(BadgeItem badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badge.isUnlocked
            ? AppColors.neonLimeDim.withAlpha(30)
            : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '+${badge.pointsReward} P',
        style: TextStyle(
          color: badge.isUnlocked ? AppColors.neonLimeDim : AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
