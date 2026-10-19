import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/workout_controller.dart';
import '../models/workout_entry.dart';
import '../widget/add_workout_sheet.dart';
import '../widget/workout_entry_tile.dart';
import '../widget/workout_quick_presets.dart';
import '../widget/workout_summary_card.dart';

class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkoutSummaryCard(
                totalCalories: controller.totalCalories,
                totalMinutes: controller.totalMinutes,
                goalCalories: controller.dailyCalorieGoal,
                progress: controller.progress,
              ),
              const SizedBox(height: 24),
              _PresetsHeader(
                onCustomTap: () => AddWorkoutSheet.show(
                  context,
                  onAdd: (title, duration, calories) {
                    controller.addWorkout(title: title, durationMinutes: duration, caloriesBurned: calories);
                  },
                ),
              ),
              const SizedBox(height: 12),
              WorkoutQuickPresets(
                onSelect: (title, duration, calories) {
                  controller.addWorkout(title: title, durationMinutes: duration, caloriesBurned: calories);
                },
              ),
              const SizedBox(height: 24),
              const _SectionTitle(title: 'Antrenman Günlüğü'),
              const SizedBox(height: 12),
              _WorkoutList(
                entries: controller.entries,
                onDelete: controller.removeWorkout,
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _PresetsHeader extends StatelessWidget {
  final VoidCallback onCustomTap;
  const _PresetsHeader({required this.onCustomTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Hızlı Şablonlar', style: theme.textTheme.titleMedium),
        TextButton.icon(
          onPressed: onCustomTap,
          icon: const Icon(Icons.add, size: 16, color: AppColors.neonLime),
          label: Text('Özel Ekle', style: theme.textTheme.titleMedium?.copyWith(color: AppColors.neonLime, fontSize: 13)),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(title, style: theme.textTheme.titleMedium);
  }
}

class _WorkoutList extends StatelessWidget {
  final List<WorkoutEntry> entries;
  final void Function(String id) onDelete;

  const _WorkoutList({required this.entries, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entries.isEmpty) {
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
            const Icon(Icons.fitness_center_rounded, color: AppColors.textMuted, size: 36),
            const SizedBox(height: 8),
            Text('Bugün henüz antrenman kaydedilmedi', style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return WorkoutEntryTile(entry: entry, onDelete: () => onDelete(entry.id));
      },
    );
  }
}
