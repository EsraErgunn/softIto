import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/workout_model.dart';

/// Tekil egzersiz kayıt kartı - Tema duyarlı
class WorkoutItemCard extends StatelessWidget {
  final WorkoutItem workout;
  final VoidCallback onDelete;

  const WorkoutItemCard({
    super.key,
    required this.workout,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? AppColors.surfaceCard;
    final borderColor = theme.dividerTheme.color ?? AppColors.surfaceBorder;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          _buildCategoryIcon(),
          const SizedBox(width: 14),
          _buildWorkoutDetails(context),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    IconData icon;
    Color color;

    switch (workout.category) {
      case 'Koşu':
        icon = Icons.directions_run_rounded;
        color = AppColors.neonLimeDim;
        break;
      case 'Bisiklet':
        icon = Icons.directions_bike_rounded;
        color = AppColors.waterPrimary;
        break;
      case 'Yüzme':
        icon = Icons.pool_rounded;
        color = AppColors.waterSecondary;
        break;
      default:
        icon = Icons.fitness_center_rounded;
        color = AppColors.firePrimary;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withAlpha(35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildWorkoutDetails(BuildContext context) {
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final subColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workout.title,
            style: TextStyle(
              color: titleColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${workout.durationMinutes} dk',
                style: TextStyle(
                  color: subColor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(width: 8),
              Text(
                '${workout.caloriesBurned} kcal',
                style: const TextStyle(
                  color: AppColors.fireSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete_outline_rounded,
          color: AppColors.textMuted, size: 20),
      onPressed: onDelete,
    );
  }
}
