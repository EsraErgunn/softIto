import 'package:flutter/material.dart';
import '../models/workout_model.dart';

class WorkoutCard extends StatelessWidget {
  final WorkoutModel data;

  const WorkoutCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Günlük Egzersiz', style: theme.textTheme.titleMedium),
                Icon(Icons.fitness_center, color: theme.colorScheme.secondary),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: data.minutesRatio,
              color: theme.colorScheme.secondary,
              minHeight: 10,
              borderRadius: BorderRadius.circular(6),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${data.activeMinutes} / ${data.targetMinutes} Dk Aktif',
                    style: theme.textTheme.bodyMedium),
                Text('${data.caloriesBurned} / ${data.targetCalories} kcal',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
