import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/weekly_day_progress.dart';

class WeeklyTrackerCard extends StatelessWidget {
  final List<WeeklyDayProgress> days;

  const WeeklyTrackerCard({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((day) => _DayColumn(day: day)).toList(),
          ),
          const SizedBox(height: 12),
          const _LegendRow(),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.date_range_rounded, color: AppColors.neonAmber, size: 20),
            const SizedBox(width: 8),
            Text('Haftalık Takip', style: theme.textTheme.titleMedium),
          ],
        ),
        Text('7 Günlük Seri', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.neonAmber)),
      ],
    );
  }
}

class _DayColumn extends StatelessWidget {
  final WeeklyDayProgress day;
  const _DayColumn({required this.day});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: day.isToday ? AppColors.surfaceElevated : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: day.isToday ? Border.all(color: AppColors.neonCyan) : null,
      ),
      child: Column(
        children: [
          Text(day.dayName, style: theme.textTheme.labelSmall),
          const SizedBox(height: 8),
          _DayDot(isMet: day.isWaterCompleted, color: AppColors.neonCyan),
          const SizedBox(height: 6),
          _DayDot(isMet: day.isWorkoutCompleted, color: AppColors.neonLime),
          const SizedBox(height: 6),
          Icon(
            day.isPerfectDay ? Icons.star_rounded : Icons.star_border_rounded,
            color: day.isPerfectDay ? AppColors.neonAmber : AppColors.textMuted,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  final bool isMet;
  final Color color;

  const _DayDot({required this.isMet, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isMet ? color : AppColors.surfaceElevated,
        border: Border.all(
          color: isMet ? color : AppColors.border,
          width: 1.5,
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _DayDot(isMet: true, color: AppColors.neonCyan),
        const SizedBox(width: 4),
        Text('Su', style: theme.textTheme.labelSmall),
        const SizedBox(width: 16),
        const _DayDot(isMet: true, color: AppColors.neonLime),
        const SizedBox(width: 4),
        Text('Egzersiz', style: theme.textTheme.labelSmall),
        const SizedBox(width: 16),
        const Icon(Icons.star_rounded, color: AppColors.neonAmber, size: 14),
        const SizedBox(width: 4),
        Text('Mükemmel', style: theme.textTheme.labelSmall),
      ],
    );
  }
}
