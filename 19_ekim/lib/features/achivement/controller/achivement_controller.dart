import 'package:flutter/material.dart';
import '../models/achievement_badge.dart';
import '../models/pet_reward.dart';
import '../models/weekly_day_progress.dart';

class AchivementController extends ChangeNotifier {
  AchivementController() {
    _initBadges();
    _initPets();
    _initWeeklyProgress();
  }

  int _basePoints = 120;
  List<AchievementBadge> _badges = [];
  List<PetReward> _pets = [];
  List<WeeklyDayProgress> _weeklyDays = [];

  int get totalPoints => _basePoints;
  List<AchievementBadge> get badges => List.unmodifiable(_badges);
  List<PetReward> get pets => List.unmodifiable(_pets);
  List<WeeklyDayProgress> get weeklyDays => List.unmodifiable(_weeklyDays);

  int get unlockedPetsCount => _pets.where((p) => p.isUnlocked).length;
  int get unlockedBadgesCount => _badges.where((b) => b.isUnlocked).length;

  void _initBadges() {
    _badges = [
      const AchievementBadge(
        id: 'first_water',
        title: 'İlk Damla',
        description: 'İlk su kaydını tamamla',
        icon: Icons.water_drop_rounded,
        pointsReward: 50,
      ),
      const AchievementBadge(
        id: 'water_goal',
        title: 'Hidrasyon Ustası',
        description: 'Günlük su hedefine ulaş',
        icon: Icons.emoji_events_rounded,
        pointsReward: 100,
      ),
      const AchievementBadge(
        id: 'first_workout',
        title: 'İlk Ter',
        description: 'İlk antrenmanını tamamla',
        icon: Icons.fitness_center_rounded,
        pointsReward: 60,
      ),
      const AchievementBadge(
        id: 'calorie_goal',
        title: 'Kalori Avcısı',
        description: 'Günlük yakım hedefini aş',
        icon: Icons.local_fire_department_rounded,
        pointsReward: 120,
      ),
      const AchievementBadge(
        id: 'weekly_streak',
        title: 'Haftalık Disiplin',
        description: 'Haftada en az 4 gün hedeflere ulaş',
        icon: Icons.military_tech_rounded,
        pointsReward: 200,
        isUnlocked: true,
      ),
    ];
  }

  void _initPets() {
    _pets = [
      const PetReward(
        id: 'cyber_wolf',
        name: 'Siber Kurt',
        emoji: '🐺',
        title: 'Gece Koruyucusu',
        requiredPoints: 200,
        description: '200 puana ulaşınca hediye edilir.',
      ),
      const PetReward(
        id: 'neon_cheetah',
        name: 'Neon Çita',
        emoji: '🐆',
        title: 'Hız Şampiyonu',
        requiredPoints: 350,
        description: '350 puana ulaşınca hediye edilir.',
      ),
      const PetReward(
        id: 'ice_bear',
        name: 'Buz Ayısı',
        emoji: '🐻‍❄️',
        title: 'Kaya Dayanıklılığı',
        requiredPoints: 500,
        description: '500 puana ulaşınca hediye edilir.',
      ),
      const PetReward(
        id: 'golden_eagle',
        name: 'Altın Kartal',
        emoji: '🦅',
        title: 'Zirve Hükümdarı',
        requiredPoints: 750,
        description: '750 puana ulaşınca hediye edilir.',
      ),
    ];
    _checkPetUnlocks();
  }

  void _initWeeklyProgress() {
    _weeklyDays = [
      const WeeklyDayProgress(dayName: 'Pzt', waterMl: 2500, waterGoalMl: 2500, caloriesBurned: 520, calorieGoal: 500),
      const WeeklyDayProgress(dayName: 'Sal', waterMl: 2600, waterGoalMl: 2500, caloriesBurned: 480, calorieGoal: 500),
      const WeeklyDayProgress(dayName: 'Çar', waterMl: 2200, waterGoalMl: 2500, caloriesBurned: 600, calorieGoal: 500),
      const WeeklyDayProgress(dayName: 'Per', waterMl: 2500, waterGoalMl: 2500, caloriesBurned: 550, calorieGoal: 500),
      const WeeklyDayProgress(dayName: 'Cum', waterMl: 2800, waterGoalMl: 2500, caloriesBurned: 300, calorieGoal: 500),
      const WeeklyDayProgress(dayName: 'Cmt', waterMl: 2500, waterGoalMl: 2500, caloriesBurned: 510, calorieGoal: 500),
      const WeeklyDayProgress(dayName: 'Paz', waterMl: 0, waterGoalMl: 2500, caloriesBurned: 0, calorieGoal: 500, isToday: true),
    ];
  }

  void syncWithActivities({
    required int waterMl,
    required int waterGoalMl,
    required int caloriesBurned,
    required int calorieGoal,
  }) {
    bool hasChanges = false;

    // Günün ilerlemesini güncelle
    for (int i = 0; i < _weeklyDays.length; i++) {
      if (_weeklyDays[i].isToday) {
        _weeklyDays[i] = WeeklyDayProgress(
          dayName: _weeklyDays[i].dayName,
          waterMl: waterMl,
          waterGoalMl: waterGoalMl,
          caloriesBurned: caloriesBurned,
          calorieGoal: calorieGoal,
          isToday: true,
        );
        hasChanges = true;
      }
    }

    // Rozetleri ve puanları kontrol et
    if (waterMl > 0) hasChanges = _unlockBadge('first_water') || hasChanges;
    if (waterMl >= waterGoalMl && waterGoalMl > 0) hasChanges = _unlockBadge('water_goal') || hasChanges;
    if (caloriesBurned > 0) hasChanges = _unlockBadge('first_workout') || hasChanges;
    if (caloriesBurned >= calorieGoal && calorieGoal > 0) hasChanges = _unlockBadge('calorie_goal') || hasChanges;

    // Su ve kalori bazlı dinamik XP ekle (100ml = 5 XP, 50 kcal = 10 XP)
    final activityPoints = (waterMl ~/ 100) * 5 + (caloriesBurned ~/ 50) * 10;
    final totalBadgePoints = _badges.where((b) => b.isUnlocked).fold<int>(0, (sum, b) => sum + b.pointsReward);
    final calculatedTotal = 120 + activityPoints + totalBadgePoints;

    if (_basePoints != calculatedTotal) {
      _basePoints = calculatedTotal;
      hasChanges = true;
    }

    if (_checkPetUnlocks()) {
      hasChanges = true;
    }

    if (hasChanges) {
      notifyListeners();
    }
  }

  bool _unlockBadge(String id) {
    final index = _badges.indexWhere((b) => b.id == id);
    if (index != -1 && !_badges[index].isUnlocked) {
      _badges[index] = _badges[index].copyWith(isUnlocked: true);
      return true;
    }
    return false;
  }

  bool _checkPetUnlocks() {
    bool unlockedAny = false;
    for (int i = 0; i < _pets.length; i++) {
      final pet = _pets[i];
      if (!pet.isUnlocked && _basePoints >= pet.requiredPoints) {
        _pets[i] = pet.copyWith(isUnlocked: true);
        unlockedAny = true;
      }
    }
    return unlockedAny;
  }

  void addBonusPoints(int points) {
    if (points <= 0) return;
    _basePoints += points;
    _checkPetUnlocks();
    notifyListeners();
  }
}
