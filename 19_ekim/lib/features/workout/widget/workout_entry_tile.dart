// =============================================================================
// workout_entry_tile.dart - Antrenman günlüğündeki tek satır
// Satır üç parçaya bölünmüştür: ikon, detaylar (ad, süre, saat) ve sağ taraf (kalori + sil).
// Küçük widget'lara bölmek build metodunu okunur tutar.
// =============================================================================

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_entry.dart';

class WorkoutEntryTile extends StatelessWidget {
  final WorkoutEntry entry;
  final VoidCallback onDelete;

  const WorkoutEntryTile({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const _EntryIcon(),
          const SizedBox(width: 12),
          _EntryDetails(entry: entry, textTheme: theme.textTheme),
          _EntryMeta(entry: entry, onDelete: onDelete, textTheme: theme.textTheme),
        ],
      ),
    );
  }
}

// Soldaki yuvarlak antrenman ikonu.
class _EntryIcon extends StatelessWidget {
  const _EntryIcon();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.neonLimeGlow,
      child: const Icon(Icons.fitness_center_rounded, color: AppColors.neonLime, size: 20),
    );
  }
}

// Antrenman adı ve "30 dakika • 14:05" bilgisi. Expanded ile ortadaki boşluğu doldurur.
class _EntryDetails extends StatelessWidget {
  final WorkoutEntry entry;
  final TextTheme textTheme;

  const _EntryDetails({required this.entry, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(entry.title, style: textTheme.titleMedium),
          const SizedBox(height: 2),
          Text('${entry.durationMinutes} dakika • ${entry.formattedTime}', style: textTheme.labelSmall),
        ],
      ),
    );
  }
}

// Sağdaki yakılan kalori ve silme butonu.
class _EntryMeta extends StatelessWidget {
  final WorkoutEntry entry;
  final VoidCallback onDelete;
  final TextTheme textTheme;

  const _EntryMeta({
    required this.entry,
    required this.onDelete,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '+${entry.caloriesBurned} kcal',
          style: textTheme.titleMedium?.copyWith(color: AppColors.neonLime),
        ),
        const SizedBox(width: 6),
        IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18),
          onPressed: onDelete,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: 'Kaydı Sil',
        ),
      ],
    );
  }
}
