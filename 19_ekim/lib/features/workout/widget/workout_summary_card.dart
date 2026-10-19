import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutSummaryCard extends StatelessWidget {
  final int totalCalories;
  final int totalMinutes;
  final int goalCalories;
  final double progress;

  const WorkoutSummaryCard({
    super.key,
    required this.totalCalories,
    required this.totalMinutes,
    required this.goalCalories,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
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
          _CardHeader(progress: progress),
          const SizedBox(height: 16),
          _MetricsRow(totalCalories: totalCalories, totalMinutes: totalMinutes, goalCalories: goalCalories),
          const SizedBox(height: 16),
          _ProgressBar(progress: progress),
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final double progress;
  const _CardHeader({required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (progress * 100).toInt();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.fitness_center_rounded, color: AppColors.neonLime, size: 22),
            const SizedBox(width: 8),
            Text('Günlük Aktivite', style: theme.textTheme.titleMedium),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.neonLimeGlow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '%$percent',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.neonLime,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricsRow extends StatelessWidget {
  final int totalCalories;
  final int totalMinutes;
  final int goalCalories;

  const _MetricsRow({
    required this.totalCalories,
    required this.totalMinutes,
    required this.goalCalories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _MetricItem(label: 'Yakılan', value: '$totalCalories', unit: 'kcal', textTheme: theme.textTheme),
        Container(width: 1, height: 36, color: AppColors.border),
        _MetricItem(label: 'Süre', value: '$totalMinutes', unit: 'dakika', textTheme: theme.textTheme),
        Container(width: 1, height: 36, color: AppColors.border),
        _MetricItem(label: 'Hedef', value: '$goalCalories', unit: 'kcal', textTheme: theme.textTheme),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final TextTheme textTheme;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: textTheme.titleLarge?.copyWith(color: AppColors.neonLime)),
        Text(unit, style: textTheme.labelSmall),
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
        minHeight: 8,
        backgroundColor: AppColors.surfaceElevated,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.neonLime),
      ),
    );
  }
}
