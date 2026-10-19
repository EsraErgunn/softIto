import 'package:flutter/material.dart';
import '../controller/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widget/water_quick_actions.dart';
import '../widget/water_tracker_card.dart';
import '../widget/weekly_pet_card.dart';

class WaterTrackerView extends StatefulWidget {
  const WaterTrackerView({super.key});

  @override
  State<WaterTrackerView> createState() => _WaterTrackerViewState();
}

class _WaterTrackerViewState extends State<WaterTrackerView> {
  late final WaterTrackerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WaterTrackerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    return ValueListenableBuilder<WaterTrackerModel>(
      valueListenable: _controller.state,
      builder: (context, data, _) {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            WaterTrackerCard(data: data),
            const SizedBox(height: 16),
            WeeklyPetCard(data: data),
            const SizedBox(height: 16),
            WaterQuickActions(
              onAddWater: _controller.addWater,
              onReset: _controller.resetWater,
            ),
          ],
        );
      },
    );
  }
}
