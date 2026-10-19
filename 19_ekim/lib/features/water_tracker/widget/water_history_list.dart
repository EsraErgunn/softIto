import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/water_intake.dart';

class WaterHistoryList extends StatelessWidget {
  final List<WaterIntake> intakes;
  final void Function(String id) onDelete;

  const WaterHistoryList({
    super.key,
    required this.intakes,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (intakes.isEmpty) {
      return const _EmptyIntakeState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: intakes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = intakes[index];
        return _IntakeTile(
          item: item,
          onDelete: () => onDelete(item.id),
        );
      },
    );
  }
}

class _EmptyIntakeState extends StatelessWidget {
  const _EmptyIntakeState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.opacity_rounded, color: AppColors.textMuted, size: 36),
          const SizedBox(height: 8),
          Text('Bugün henüz su kaydı eklenmedi', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _IntakeTile extends StatelessWidget {
  final WaterIntake item;
  final VoidCallback onDelete;

  const _IntakeTile({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: AppColors.neonCyan, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text('+${item.amountMl} ml', style: theme.textTheme.titleMedium),
          ),
          Text(item.formattedTime, style: theme.textTheme.labelSmall),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Kaydı Sil',
          ),
        ],
      ),
    );
  }
}
