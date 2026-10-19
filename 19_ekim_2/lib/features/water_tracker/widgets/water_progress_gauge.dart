import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_tracker_model.dart';

/// Neon ışıltılı dairesel su ilerleme göstergesi - Açık/Koyu tema duyarlı
class WaterProgressGauge extends StatelessWidget {
  final WaterTrackerModel model;

  const WaterProgressGauge({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? AppColors.surfaceCard;
    final borderColor = theme.dividerTheme.color ?? AppColors.surfaceBorder;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1500E5FF),
            blurRadius: 24,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCircularIndicator(context),
          const SizedBox(height: 18),
          _buildGoalSubtitle(context),
        ],
      ),
    );
  }

  Widget _buildCircularIndicator(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildGlowBackground(context),
          _buildProgressRing(context),
          _buildCenterStats(context),
        ],
      ),
    );
  }

  Widget _buildGlowBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.waterBackground.withAlpha(120)
            : AppColors.lightWaterBackground,
      ),
    );
  }

  Widget _buildProgressRing(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 180,
      height: 180,
      child: CircularProgressIndicator(
        value: model.progressRatio,
        strokeWidth: 14,
        strokeCap: StrokeCap.round,
        backgroundColor: isDark
            ? AppColors.surfaceElevated
            : AppColors.lightSurfaceElevated,
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.waterPrimary),
      ),
    );
  }

  Widget _buildCenterStats(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final subColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.water_drop_rounded,
          color: AppColors.waterPrimary,
          size: 30,
        ),
        const SizedBox(height: 4),
        Text(
          '${model.consumedMl}',
          style: TextStyle(
            color: textColor,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
        ),
        Text(
          'Hedef: ${model.dailyGoalMl} ml',
          style: TextStyle(
            color: subColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSubtitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final border = isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, color: AppColors.neonLimeDim, size: 18),
          const SizedBox(width: 6),
          Text(
            '%${model.percentage} tamamlandı • Kalan: ${model.remainingMl} ml',
            style: const TextStyle(
              color: AppColors.neonLimeDim,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
