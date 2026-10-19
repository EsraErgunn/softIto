import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_tracker_model.dart';

/// Hidrasyon istatistikleri ve motivasyon kartı - Tema duyarlı
class HydrationStatsCard extends StatelessWidget {
  final WaterTrackerModel model;

  const HydrationStatsCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? AppColors.surfaceCard;
    final borderColor = theme.dividerTheme.color ?? AppColors.surfaceBorder;
    final glassCount = (model.consumedMl / 250).floor();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTipHeader(context),
          const SizedBox(height: 12),
          _buildStatsRow(glassCount),
        ],
      ),
    );
  }

  Widget _buildTipHeader(BuildContext context) {
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Row(
      children: [
        const Icon(Icons.lightbulb_outline_rounded,
            color: AppColors.neonAmber, size: 20),
        const SizedBox(width: 8),
        Text(
          'Günün Hidrasyon İpucu',
          style: TextStyle(
            color: titleColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(int glassCount) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            label: 'İçilen Bardak',
            value: '$glassCount bardak',
            icon: Icons.local_drink_rounded,
            color: AppColors.waterPrimary,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: _StatBox(
            label: 'Su Kalitesi',
            value: 'Taze & Canlı',
            icon: Icons.eco_rounded,
            color: AppColors.neonLimeDim,
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boxBg = isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final boxBorder = isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder;
    final valColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: boxBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: boxBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: valColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
