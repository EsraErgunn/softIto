import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/workout_controller.dart';
import '../models/workout_model.dart';
import '../widgets/add_workout_dialog.dart';
import '../widgets/calorie_summary_card.dart';
import '../widgets/workout_item_card.dart';

/// Egzersiz ve Kalori Takip Ekranı
class WorkoutView extends StatelessWidget {
  final WorkoutController controller;

  const WorkoutView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<WorkoutSummaryModel>(
          valueListenable: controller.state,
          builder: (context, summary, _) {
            return _buildContentList(context, summary);
          },
        ),
      ),
    );
  }

  Widget _buildContentList(BuildContext context, WorkoutSummaryModel summary) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        CalorieSummaryCard(
          model: summary,
          onAddWorkout: () => _openAddSheet(context),
        ),
        const SizedBox(height: 24),
        _buildSectionTitle(summary.workouts.length),
        const SizedBox(height: 12),
        if (summary.workouts.isEmpty)
          _buildEmptyState()
        else
          ...summary.workouts.map(
            (item) => WorkoutItemCard(
              workout: item,
              onDelete: () => controller.removeWorkout(item.id),
            ),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.workoutTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4),
        Text(
          AppStrings.workoutSubtitle,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Bugünün Antrenmanları',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '$count Kayıt',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: const Center(
        child: Text(
          AppStrings.noWorkoutsYet,
          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
        ),
      ),
    );
  }

  void _openAddSheet(BuildContext context) {
    AddWorkoutBottomSheet.show(
      context,
      onSave: ({
        required String title,
        required String category,
        required int durationMinutes,
        required int caloriesBurned,
      }) {
        controller.addWorkout(
          title: title,
          category: category,
          durationMinutes: durationMinutes,
          caloriesBurned: caloriesBurned,
        );
      },
    );
  }
}
