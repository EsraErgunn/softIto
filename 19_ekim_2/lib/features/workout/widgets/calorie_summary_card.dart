import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

/// Kalori ve egzersiz süresi özet kartı - Tema duyarlı
class CalorieSummaryCard extends StatelessWidget {
  final WorkoutSummaryModel model;
  final VoidCallback onAddWorkout;

  const CalorieSummaryCard({
    super.key,
    required this.model,
    required this.onAddWorkout,
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x15FF5722),
            blurRadius: 24,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(context),
          const SizedBox(height: 16),
          _buildMainStats(context),
          const SizedBox(height: 16),
          _buildProgressBar(context),
          const SizedBox(height: 16),
          _buildActionBtn(),
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagBg = isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final tagBorder = isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.local_fire_department_rounded,
                color: AppColors.firePrimary, size: 22),
            const SizedBox(width: 8),
            Text(
              'Aktif Kalori & Süre',
              style: TextStyle(
                color: titleColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: tagBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: tagBorder),
          ),
          child: Text(
            'Hedef: ${model.dailyCalorieGoal} kcal',
            style: const TextStyle(
              color: AppColors.fireSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainStats(BuildContext context) {
    final mainColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final dividerColor = Theme.of(context).dividerColor;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.totalCaloriesBurned}',
                style: TextStyle(
                  color: mainColor,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const Text(
                'Toplam Yakılan (kcal)',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          width: 1,
          color: dividerColor,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.totalDurationMinutes} dk',
                style: const TextStyle(
                  color: AppColors.neonLimeDim,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const Text(
                'Toplam Egzersiz Süresi',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barBg = isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Günlük Hedef: %${(model.progressRatio * 100).toInt()}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Kalan: ${model.remainingCalories} kcal',
              style: const TextStyle(
                color: AppColors.fireSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: model.progressRatio,
            minHeight: 10,
            backgroundColor: barBg,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.firePrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildActionBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onAddWorkout,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.firePrimary,
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text('Yeni Egzersiz Kaydet'),
      ),
    );
  }
}
