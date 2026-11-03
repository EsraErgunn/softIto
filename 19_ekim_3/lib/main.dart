// =============================================================================
// main.dart - "Susadım" (19_ekim_3 sürümü) giriş noktası
// Sade bir mimari: her sekme (View) kendi controller'ını kendisi oluşturur.
// Tema, tek bir ortak ThemeController (singleton) üzerinden yönetilir.
// Kural: her build metodu en fazla ~40 satır olacak şekilde küçük widget'lara bölünmüştür.
// =============================================================================

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/achievement/view/achievement_view.dart';
import 'features/water_tracker/view/water_tracker_view.dart';
import 'features/workout/view/workout_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

class SusadimApp extends StatelessWidget {
  const SusadimApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Susadım',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // Tema modu değişince ValueListenableBuilder MaterialApp'i yeniden kurar;
          // theme (açık) / darkTheme (koyu) arasından themeMode'a göre seçim yapılır.
          themeMode: themeMode,
          home: const MainHomeScreen(),
        );
      },
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

// Alt menülü ana ekran.
class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;

  // Sekmeler const olarak bir kez tanımlanır. Her biri kendi controller'ını
  // initState'te oluşturduğu için burada controller verilmez.
  static const List<Widget> _pages = [
    WaterTrackerView(),
    WorkoutView(),
    AchievementView(),
  ];

  // Seçili sekmeye göre AppBar başlığı bu listeden alınır.
  static const List<String> _titles = [
    'Susadım - Su Takibi',
    'Susadım - Egzersiz & Kalori',
    'Susadım - Rozetler & Ödüller',
  ];

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: const [_ThemeToggleButton()],
      ),
      body: SafeArea(
        // IndexedStack sayesinde sekme değişince sayfalar yok edilmez, durumları korunur.
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.water_drop_outlined), selectedIcon: Icon(Icons.water_drop), label: 'Su'),
          NavigationDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: 'Egzersiz'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events), label: 'Ödüller'),
        ],
      ),
    );
  }
}

// AppBar'daki tema butonu: koyu moddaysa ay, değilse güneş ikonu gösterir.
class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    // 40 satır kuralına uygun
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, mode, _) {
        final icon = mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode;
        return IconButton(
          icon: Icon(icon),
          tooltip: 'Temayı Değiştir',
          onPressed: ThemeController.instance.toggleTheme,
        );
      },
    );
  }
}
