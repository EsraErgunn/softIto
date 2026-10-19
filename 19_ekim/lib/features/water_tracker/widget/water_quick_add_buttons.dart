import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WaterQuickAddButtons extends StatelessWidget {
  final void Function(int amount) onAdd;

  const WaterQuickAddButtons({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickAddCard(amount: 150, label: 'Bardak', icon: Icons.local_drink_outlined, onTap: () => onAdd(150)),
        const SizedBox(width: 8),
        _QuickAddCard(amount: 250, label: 'Kupa', icon: Icons.coffee_rounded, onTap: () => onAdd(250)),
        const SizedBox(width: 8),
        _QuickAddCard(amount: 500, label: 'Şişe', icon: Icons.sports_bar_outlined, onTap: () => onAdd(500)),
        const SizedBox(width: 8),
        _QuickAddCard(amount: 750, label: 'Termos', icon: Icons.fitness_center_rounded, onTap: () => onAdd(750)),
      ],
    );
  }
}

class _QuickAddCard extends StatelessWidget {
  final int amount;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAddCard({
    required this.amount,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.neonCyan, size: 22),
              const SizedBox(height: 6),
              Text('+$amount', style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
              const SizedBox(height: 2),
              Text(label, style: theme.textTheme.labelSmall),
            ],
          ),
        ),
      ),
    );
  }
}
