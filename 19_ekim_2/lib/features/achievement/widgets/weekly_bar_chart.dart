import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/achievement_model.dart';

/// 7 günlük performans ve hedef tamamlama grafiği - Tema duyarlı
class WeeklyBarChart extends StatelessWidget {
  final List<DailyRecord> records;

  const WeeklyBarChart({
    super.key,
    required this.records,
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
          const SizedBox(height: 20),
          _buildBarsRow(context),
          const SizedBox(height: 16),
          _buildLegend(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Row(
      children: [
        const Icon(Icons.calendar_month_rounded,
            color: AppColors.waterPrimary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Haftalık Disiplin Tablosu',
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildBarsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: records.map((rec) => _buildDayColumn(context, rec)).toList(),
    );
  }

  Widget _buildDayColumn(BuildContext context, DailyRecord rec) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final heightRatio = (rec.waterMl / 3000).clamp(0.15, 1.0);
    final isComplete = rec.waterGoalReached && rec.calorieGoalReached;
    final inactiveBg =
        isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final borderColor =
        isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 110 * heightRatio,
          decoration: BoxDecoration(
            color: isComplete
                ? AppColors.neonLimeDim
                : (rec.isToday ? AppColors.waterPrimary : inactiveBg),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: rec.isToday ? AppColors.waterPrimary : borderColor,
              width: rec.isToday ? 2 : 1,
            ),
          ),
          child: Center(
            child: Icon(
              isComplete
                  ? Icons.check_circle_rounded
                  : (rec.waterGoalReached
                      ? Icons.water_drop_rounded
                      : Icons.circle_outlined),
              size: 14,
              color: isComplete ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          rec.dayName,
          style: TextStyle(
            color: rec.isToday ? AppColors.waterPrimary : AppColors.textMuted,
            fontSize: 12,
            fontWeight: rec.isToday ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dotColor =
        isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _LegendDot(color: AppColors.neonLimeDim, label: 'Tam Başarı'),
        const SizedBox(width: 16),
        const _LegendDot(color: AppColors.waterPrimary, label: 'Bugün'),
        const SizedBox(width: 16),
        _LegendDot(color: dotColor, label: 'Devam Eden'),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }
}
