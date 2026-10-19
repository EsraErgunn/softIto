import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterStatsRow extends StatelessWidget {
  final int remainingMl;
  final int dailyGoalMl;
  final bool isGoalReached;

  const WaterStatsRow({
    super.key,
    required this.remainingMl,
    required this.dailyGoalMl,
    required this.isGoalReached,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(
          title: 'Kalan',
          value: isGoalReached ? 'Hedef Tamam!' : '$remainingMl ml',
          icon: isGoalReached ? Icons.check_circle_outline : Icons.hourglass_bottom_rounded,
          iconColor: isGoalReached ? AppColors.neonLime : AppColors.neonAmber,
        ),
        const SizedBox(width: 12),
        _StatTile(
          title: 'Günlük Hedef',
          value: '$dailyGoalMl ml',
          icon: Icons.flag_outlined,
          iconColor: AppColors.neonCyan,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: iconColor.withValues(alpha: 0.15),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: theme.textTheme.labelSmall),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
