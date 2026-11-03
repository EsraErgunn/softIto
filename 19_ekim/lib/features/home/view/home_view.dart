// =============================================================================
// home_view.dart - Ana iskelet ekran (alt menülü 3 sekme)
// Üç controller (su, antrenman, başarım) burada BİR KEZ oluşturulur ve sekmelere
// parametre olarak verilir. Su veya antrenman değişince başarım controller'ı
// otomatik güncellenir (controller'lar arası köprü bu ekrandır).
// =============================================================================

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
  // Seçili alt menü sekmesi (0: Su, 1: Egzersiz, 2: Ödüller).
  int _currentIndex = 0;
  // late final: değer initState'te atanacak ve bir daha değişmeyecek.
  late final WaterController _waterController;
  late final WorkoutController _workoutController;
  late final AchivementController _achivementController;

  @override
  void initState() {
    super.initState();
    _waterController = WaterController();
    _workoutController = WorkoutController();
    _achivementController = AchivementController();

    // Su veya antrenman controller'ı notifyListeners() çağırınca _syncActivities
    // çalışır ve başarım sistemi yeni verilerle güncellenir.
    _waterController.addListener(_syncActivities);
    _workoutController.addListener(_syncActivities);
    _syncActivities();
  }

  // Güncel su ve kalori değerlerini başarım controller'ına aktarır.
  void _syncActivities() {
    _achivementController.syncWithActivities(
      waterMl: _waterController.currentAmountMl,
      waterGoalMl: _waterController.dailyGoalMl,
      caloriesBurned: _workoutController.totalCalories,
      calorieGoal: _workoutController.dailyCalorieGoal,
    );
  }

  @override
  // Ekran kapanırken dinleyiciler kaldırılır ve controller'lar dispose edilir;
  // aksi halde bellek sızıntısı (memory leak) oluşur.
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
      // IndexedStack: tüm sekmeleri bellekte tutar, sadece seçili olanı gösterir.
      // Sekme değişince kaydırma konumu gibi durumlar kaybolmaz.
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
        // Alt menüde sekmeye basılınca seçili index güncellenir ve ekran yeniden çizilir.
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// Scaffold.appBar bir PreferredSizeWidget ister; bu yüzden yüksekliği bildiren
// preferredSize getter'ı yazılmak zorunda.
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  const _HomeAppBar({required this.currentIndex});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // Dart 3 switch ifadesi: sekmeye göre başlık seçer. "_" geri kalan tüm durumlar demektir.
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

// Alt menü çubuğu. Seçim olayını ValueChanged<int> callback'i ile üst widget'a bildirir.
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
