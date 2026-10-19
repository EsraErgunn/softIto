import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WorkoutQuickPresets extends StatelessWidget {
  final void Function(String title, int duration, int calories) onSelect;

  const WorkoutQuickPresets({super.key, required this.onSelect});

  static const _presets = [
    (title: 'Ağırlık', duration: 45, calories: 280, icon: Icons.fitness_center),
    (title: 'Koşu', duration: 30, calories: 320, icon: Icons.directions_run),
    (title: 'Bisiklet', duration: 25, calories: 200, icon: Icons.directions_bike),
    (title: 'HIIT', duration: 20, calories: 240, icon: Icons.flash_on_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _presets.map((preset) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _PresetCard(
              title: preset.title,
              duration: preset.duration,
              calories: preset.calories,
              icon: preset.icon,
              onTap: () => onSelect(preset.title, preset.duration, preset.calories),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final String title;
  final int duration;
  final int calories;
  final IconData icon;
  final VoidCallback onTap;

  const _PresetCard({
    required this.title,
    required this.duration,
    required this.calories,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.neonLime, size: 22),
            const SizedBox(height: 6),
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 12)),
            const SizedBox(height: 2),
            Text('${duration}dk • ${calories}k', style: theme.textTheme.labelSmall?.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
