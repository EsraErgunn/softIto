import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/achievement_controller.dart';
import '../models/achievement_model.dart';
import '../widgets/badge_grid.dart';
import '../widgets/pet_gift_card.dart';
import '../widgets/weekly_bar_chart.dart';

/// Haftalık takip, rozetler ve hediye hayvan ekranı
class AchievementView extends StatelessWidget {
  final AchievementController controller;

  const AchievementView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<AchievementModel>(
          valueListenable: controller.state,
          builder: (context, model, _) {
            return _buildContentList(model);
          },
        ),
      ),
    );
  }

  Widget _buildContentList(AchievementModel model) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        _buildHeader(model.streakDays),
        const SizedBox(height: 20),
        WeeklyBarChart(records: model.weeklyRecords),
        const SizedBox(height: 20),
        PetGiftCard(
          model: model,
          onSelectPet: controller.selectActivePet,
        ),
        const SizedBox(height: 20),
        BadgeGrid(badges: model.badges),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader(int streak) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                AppStrings.achievementTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0x3039FF14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '🔥 $streak Gün Seri',
                style: const TextStyle(
                  color: Color(0xFF39FF14),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          AppStrings.achievementSubtitle,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
