import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../achivement/controller/achivement_controller.dart';
import '../../achivement/view/achivement_view.dart';
import '../../water_tracker/controller/water_controller.dart';
import '../../water_tracker/view/water_tracker_view.dart';
import '../../workout/controller/workout_controller.dart';
import '../../workout/view/workout_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late final WaterController _waterController;
  late final WorkoutController _workoutController;
  late final AchivementController _achivementController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterController();
    _workoutController = WorkoutController();
    _achivementController = AchivementController();

    _waterController.addListener(_syncActivities);
    _workoutController.addListener(_syncActivities);
    _syncActivities();
  }

  void _syncActivities() {
    _achivementController.syncWithActivities(
      waterMl: _waterController.currentAmountMl,
      waterGoalMl: _waterController.dailyGoalMl,
      caloriesBurned: _workoutController.totalCalories,
      calorieGoal: _workoutController.dailyCalorieGoal,
    );
  }

  @override
  void dispose() {
    _waterController.removeListener(_syncActivities);
    _workoutController.removeListener(_syncActivities);
    _waterController.dispose();
    _workoutController.dispose();
    _achivementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _HomeAppBar(currentIndex: _currentIndex),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          WaterTrackerView(controller: _waterController),
          WorkoutView(controller: _workoutController),
          AchivementView(controller: _achivementController),
        ],
      ),
      bottomNavigationBar: _HomeNavigationBar(
        currentIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  const _HomeAppBar({required this.currentIndex});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final title = switch (currentIndex) {
      0 => '💧 Susadım - Su Takibi',
      1 => '⚡ Susadım - Egzersiz',
      _ => '🏆 Susadım - Başarı & Ödüller',
    };
    return AppBar(
      title: Text(title),
    );
  }
}

class _HomeNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const _HomeNavigationBar({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop, color: AppColors.neonCyan),
          label: 'Su Takibi',
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center, color: AppColors.neonLime),
          label: 'Egzersiz',
        ),
        NavigationDestination(
          icon: Icon(Icons.emoji_events_outlined),
          selectedIcon: Icon(Icons.emoji_events_rounded, color: AppColors.neonAmber),
          label: 'Ödüller',
        ),
      ],
    );
  }
}
