import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/achievement/controllers/achievement_controller.dart';
import 'features/achievement/view/achievement_view.dart';
import 'features/water_tracker/controllers/water_tracker_controller.dart';
import 'features/water_tracker/view/water_tracker_view.dart';
import 'features/workout/controllers/workout_controller.dart';
import 'features/workout/view/workout_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

/// Susadım v1 Ana Uygulama Kökü - Aydınlık / Karanlık Tema Desteği
class SusadimApp extends StatefulWidget {
  const SusadimApp({super.key});

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: MainNavigationShell(themeController: _themeController),
        );
      },
    );
  }
}

/// Sekmeler arası geçişi sağlayan ana kabuk widget'ı
class MainNavigationShell extends StatefulWidget {
  final ThemeController themeController;

  const MainNavigationShell({
    super.key,
    required this.themeController,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  late final WaterTrackerController _waterController;
  late final WorkoutController _workoutController;
  late final AchievementController _achievementController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterTrackerController();
    _workoutController = WorkoutController();
    _achievementController = AchievementController();
  }

  @override
  void dispose() {
    _waterController.dispose();
    _workoutController.dispose();
    _achievementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      WaterTrackerView(controller: _waterController),
      WorkoutView(controller: _workoutController),
      AchievementView(controller: _achievementController),
    ];

    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _buildAppTitle(),
      actions: [
        _buildThemeToggleBtn(),
        _buildPointsBadge(),
      ],
    );
  }

  Widget _buildAppTitle() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.neonCyan.withAlpha(120)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.asset(
              'assets/images/app_logo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.water_drop_rounded,
                color: AppColors.neonCyan,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeToggleBtn() {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: widget.themeController.themeModeNotifier,
      builder: (context, mode, _) {
        IconData icon;
        String tooltip;
        switch (mode) {
          case ThemeMode.system:
            icon = Icons.brightness_auto_rounded;
            tooltip = 'Sistem Teması';
            break;
          case ThemeMode.dark:
            icon = Icons.dark_mode_rounded;
            tooltip = 'Karanlık Mod';
            break;
          case ThemeMode.light:
            icon = Icons.light_mode_rounded;
            tooltip = 'Aydınlık Mod';
            break;
        }

        return IconButton(
          tooltip: tooltip,
          icon: Icon(icon, size: 20),
          onPressed: widget.themeController.toggleTheme,
        );
      },
    );
  }

  Widget _buildPointsBadge() {
    return ValueListenableBuilder(
      valueListenable: _achievementController.state,
      builder: (context, achievement, _) {
        return Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.stars_rounded,
                  color: AppColors.neonAmber, size: 16),
              const SizedBox(width: 4),
              Text(
                '${achievement.totalPoints} P',
                style: const TextStyle(
                  color: AppColors.neonAmber,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() => _currentIndex = index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.water_drop_outlined),
          selectedIcon: Icon(Icons.water_drop_rounded),
          label: AppStrings.tabWater,
        ),
        NavigationDestination(
          icon: Icon(Icons.fitness_center_outlined),
          selectedIcon: Icon(Icons.fitness_center_rounded),
          label: AppStrings.tabWorkout,
        ),
        NavigationDestination(
          icon: Icon(Icons.emoji_events_outlined),
          selectedIcon: Icon(Icons.emoji_events_rounded),
          label: AppStrings.tabWeekly,
        ),
      ],
    );
  }
}
