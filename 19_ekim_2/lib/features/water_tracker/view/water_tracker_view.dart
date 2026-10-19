import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/water_tracker_controller.dart';
import '../models/water_tracker_model.dart';
import '../widgets/hydration_stats_card.dart';
import '../widgets/quick_add_card.dart';
import '../widgets/water_progress_gauge.dart';

/// Su takip ekranı - Clean UI ve ValueNotifier mimarisi
class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<WaterTrackerModel>(
          valueListenable: controller.state,
          builder: (context, model, _) {
            return _buildContentList(model);
          },
        ),
      ),
    );
  }

  Widget _buildContentList(WaterTrackerModel model) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        WaterProgressGauge(model: model),
        const SizedBox(height: 20),
        QuickAddCard(
          onAddWater: controller.addWater,
          onUndo: controller.removeLastIntake,
          onReset: controller.resetWater,
        ),
        const SizedBox(height: 20),
        HydrationStatsCard(model: model),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.waterTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          AppStrings.waterSubtitle,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
