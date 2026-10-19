import 'package:flutter/material.dart';
import '../models/water_tracker_model.dart';

class WeeklyPetCard extends StatelessWidget {
  final WaterTrackerModel data;

  const WeeklyPetCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    final theme = Theme.of(context);
    final hasPet = data.unlockedPetName != null;

    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              hasPet ? Icons.pets : Icons.military_tech,
              size: 38,
              color: hasPet
                  ? theme.colorScheme.primary
                  : theme.colorScheme.secondary,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasPet
                        ? 'Hediye Hayvan: ${data.unlockedPetName}'
                        : 'Haftalık Rozet Hedefi',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Puan: ${data.weeklyPoints} / 500 • Seri: ${data.completedDaysStreak} Gün',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
