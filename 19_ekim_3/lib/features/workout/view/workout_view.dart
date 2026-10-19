import 'package:flutter/material.dart';
import '../controller/workout_controller.dart';
import '../models/workout_model.dart';
import '../widget/workout_card.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  late final WorkoutController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WorkoutController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    return ValueListenableBuilder<WorkoutModel>(
      valueListenable: _controller.state,
      builder: (context, data, _) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            WorkoutCard(data: data),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _controller.addWorkout(minutes: 15, calories: 120),
              icon: const Icon(Icons.add),
              label: const Text('+15 Dk Koşu / Kardiyo (120 kcal)'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _controller.reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Egzersizi Sıfırla'),
            ),
          ],
        );
      },
    );
  }
}
