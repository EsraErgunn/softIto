import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Hızlı su ekleme butonlarını içeren modüler bileşen - Tema duyarlı
class QuickAddCard extends StatelessWidget {
  final ValueChanged<int> onAddWater;
  final VoidCallback onUndo;
  final VoidCallback onReset;

  const QuickAddCard({
    super.key,
    required this.onAddWater,
    required this.onUndo,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? AppColors.surfaceCard;
    final borderColor = theme.dividerTheme.color ?? AppColors.surfaceBorder;

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
          _buildHeader(context),
          const SizedBox(height: 14),
          _buildQuickButtonsGrid(),
          const SizedBox(height: 12),
          _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Row(
      children: [
        const Icon(Icons.add_circle_outline_rounded,
            color: AppColors.waterPrimary, size: 20),
        const SizedBox(width: 8),
        Text(
          'Hızlı Su Ekle',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickButtonsGrid() {
    return Row(
      children: [
        Expanded(
          child: _QuickButton(
            title: '+250 ml',
            subtitle: 'Bardak',
            icon: Icons.local_cafe_outlined,
            onTap: () => onAddWater(250),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickButton(
            title: '+500 ml',
            subtitle: 'Şişe',
            icon: Icons.water_drop_outlined,
            onTap: () => onAddWater(500),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickButton(
            title: '+750 ml',
            subtitle: 'Matara',
            icon: Icons.fitness_center_outlined,
            onTap: () => onAddWater(750),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: onUndo,
          icon: const Icon(Icons.undo_rounded, size: 16),
          label: const Text(
            'Son Kaydı Geri Al',
            style: TextStyle(fontSize: 13),
          ),
        ),
        TextButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.error),
          label: const Text(
            'Sıfırla',
            style: TextStyle(color: AppColors.error, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final btnBorder = isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder;
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: btnBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: btnBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.waterPrimary, size: 24),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
