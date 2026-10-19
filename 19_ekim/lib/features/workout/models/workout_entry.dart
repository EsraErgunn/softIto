import 'package:flutter/foundation.dart';

@immutable
class WorkoutEntry {
  final String id;
  final String title;
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;

  const WorkoutEntry({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
  });

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
