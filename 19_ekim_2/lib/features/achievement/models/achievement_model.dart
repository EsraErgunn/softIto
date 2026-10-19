import 'package:flutter/foundation.dart';

@immutable
class DailyRecord {
  final String dayName;
  final int waterMl;
  final int caloriesBurned;
  final bool waterGoalReached;
  final bool calorieGoalReached;
  final bool isToday;

  const DailyRecord({
    required this.dayName,
    required this.waterMl,
    required this.caloriesBurned,
    required this.waterGoalReached,
    required this.calorieGoalReached,
    required this.isToday,
  });

  DailyRecord copyWith({
    String? dayName,
    int? waterMl,
    int? caloriesBurned,
    bool? waterGoalReached,
    bool? calorieGoalReached,
    bool? isToday,
  }) {
    return DailyRecord(
      dayName: dayName ?? this.dayName,
      waterMl: waterMl ?? this.waterMl,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      waterGoalReached: waterGoalReached ?? this.waterGoalReached,
      calorieGoalReached: calorieGoalReached ?? this.calorieGoalReached,
      isToday: isToday ?? this.isToday,
    );
  }

  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    return DailyRecord(
      dayName: json['dayName'] as String? ?? '',
      waterMl: json['waterMl'] as int? ?? 0,
      caloriesBurned: json['caloriesBurned'] as int? ?? 0,
      waterGoalReached: json['waterGoalReached'] as bool? ?? false,
      calorieGoalReached: json['calorieGoalReached'] as bool? ?? false,
      isToday: json['isToday'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayName': dayName,
      'waterMl': waterMl,
      'caloriesBurned': caloriesBurned,
      'waterGoalReached': waterGoalReached,
      'calorieGoalReached': calorieGoalReached,
      'isToday': isToday,
    };
  }
}

@immutable
class BadgeItem {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final bool isUnlocked;
  final int pointsReward;

  const BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.isUnlocked,
    required this.pointsReward,
  });

  BadgeItem copyWith({
    String? id,
    String? title,
    String? description,
    String? iconName,
    bool? isUnlocked,
    int? pointsReward,
  }) {
    return BadgeItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      pointsReward: pointsReward ?? this.pointsReward,
    );
  }

  factory BadgeItem.fromJson(Map<String, dynamic> json) {
    return BadgeItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'award',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      pointsReward: json['pointsReward'] as int? ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'isUnlocked': isUnlocked,
      'pointsReward': pointsReward,
    };
  }
}

@immutable
class PetGiftItem {
  final String id;
  final String name;
  final String species;
  final String emoji;
  final int requiredPoints;
  final String description;
  final bool isUnlocked;

  const PetGiftItem({
    required this.id,
    required this.name,
    required this.species,
    required this.emoji,
    required this.requiredPoints,
    required this.description,
    required this.isUnlocked,
  });

  PetGiftItem copyWith({
    String? id,
    String? name,
    String? species,
    String? emoji,
    int? requiredPoints,
    String? description,
    bool? isUnlocked,
  }) {
    return PetGiftItem(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      emoji: emoji ?? this.emoji,
      requiredPoints: requiredPoints ?? this.requiredPoints,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  factory PetGiftItem.fromJson(Map<String, dynamic> json) {
    return PetGiftItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      species: json['species'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '🐾',
      requiredPoints: json['requiredPoints'] as int? ?? 500,
      description: json['description'] as String? ?? '',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'emoji': emoji,
      'requiredPoints': requiredPoints,
      'description': description,
      'isUnlocked': isUnlocked,
    };
  }
}

@immutable
class AchievementModel {
  final int totalPoints;
  final int streakDays;
  final List<DailyRecord> weeklyRecords;
  final List<BadgeItem> badges;
  final List<PetGiftItem> pets;
  final String activePetId;

  const AchievementModel({
    required this.totalPoints,
    required this.streakDays,
    required this.weeklyRecords,
    required this.badges,
    required this.pets,
    required this.activePetId,
  });

  factory AchievementModel.initial() {
    return const AchievementModel(
      totalPoints: 1250,
      streakDays: 5,
      activePetId: 'pet_otter',
      weeklyRecords: [
        DailyRecord(dayName: 'Pzt', waterMl: 2600, caloriesBurned: 520, waterGoalReached: true, calorieGoalReached: true, isToday: false),
        DailyRecord(dayName: 'Sal', waterMl: 2400, caloriesBurned: 450, waterGoalReached: true, calorieGoalReached: false, isToday: false),
        DailyRecord(dayName: 'Çar', waterMl: 2800, caloriesBurned: 650, waterGoalReached: true, calorieGoalReached: true, isToday: false),
        DailyRecord(dayName: 'Per', waterMl: 2100, caloriesBurned: 380, waterGoalReached: false, calorieGoalReached: false, isToday: false),
        DailyRecord(dayName: 'Cum', waterMl: 2500, caloriesBurned: 600, waterGoalReached: true, calorieGoalReached: true, isToday: false),
        DailyRecord(dayName: 'Cmt', waterMl: 2700, caloriesBurned: 710, waterGoalReached: true, calorieGoalReached: true, isToday: false),
        DailyRecord(dayName: 'Paz', waterMl: 1250, caloriesBurned: 450, waterGoalReached: false, calorieGoalReached: false, isToday: true),
      ],
      badges: [
        BadgeItem(
          id: 'b1',
          title: 'Su Ejderi',
          description: 'Günlük 2500 ml su hedefini tamamla',
          iconName: 'water',
          isUnlocked: true,
          pointsReward: 150,
        ),
        BadgeItem(
          id: 'b2',
          title: 'Ateş Çemberi',
          description: 'Günde 500+ aktif kalori yak',
          iconName: 'fire',
          isUnlocked: true,
          pointsReward: 200,
        ),
        BadgeItem(
          id: 'b3',
          title: 'Demir İrade',
          description: 'Üst üste 5 gün hedeflerini tamamla',
          iconName: 'shield',
          isUnlocked: true,
          pointsReward: 350,
        ),
        BadgeItem(
          id: 'b4',
          title: 'Haftalık Şampiyon',
          description: 'Haftanın tüm günlerinde aktif ol',
          iconName: 'trophy',
          isUnlocked: false,
          pointsReward: 500,
        ),
      ],
      pets: [
        PetGiftItem(
          id: 'pet_otter',
          name: 'Piti',
          species: 'Deniz Samuru',
          emoji: '🦦',
          requiredPoints: 500,
          description: 'Suyu çok sever, her 250 ml su içtiğinde mutlu olur!',
          isUnlocked: true,
        ),
        PetGiftItem(
          id: 'pet_dolphin',
          name: 'Maviş',
          species: 'Akıllı Yunus',
          emoji: '🐬',
          requiredPoints: 1200,
          description: 'Okyanus hızında kalori yakmanı ve bol su içmeni kutlar!',
          isUnlocked: true,
        ),
        PetGiftItem(
          id: 'pet_panda',
          name: 'Bambu',
          species: 'Enerjik Panda',
          emoji: '🐼',
          requiredPoints: 2000,
          description: 'Egzersiz sonrası bambu suyunu yudumlayıp seni alkışlar!',
          isUnlocked: false,
        ),
        PetGiftItem(
          id: 'pet_tiger',
          name: 'Pars',
          species: 'Ateş Kaplanı',
          emoji: '🐅',
          requiredPoints: 3500,
          description: 'Gece spor salonunun en güçlü ve efsanevi neon koruyucusu!',
          isUnlocked: false,
        ),
      ],
    );
  }

  AchievementModel copyWith({
    int? totalPoints,
    int? streakDays,
    List<DailyRecord>? weeklyRecords,
    List<BadgeItem>? badges,
    List<PetGiftItem>? pets,
    String? activePetId,
  }) {
    return AchievementModel(
      totalPoints: totalPoints ?? this.totalPoints,
      streakDays: streakDays ?? this.streakDays,
      weeklyRecords: weeklyRecords ?? this.weeklyRecords,
      badges: badges ?? this.badges,
      pets: pets ?? this.pets,
      activePetId: activePetId ?? this.activePetId,
    );
  }

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      totalPoints: json['totalPoints'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      activePetId: json['activePetId'] as String? ?? 'pet_otter',
      weeklyRecords: (json['weeklyRecords'] as List<dynamic>?)
              ?.map((e) => DailyRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => BadgeItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pets: (json['pets'] as List<dynamic>?)
              ?.map((e) => PetGiftItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'streakDays': streakDays,
      'activePetId': activePetId,
      'weeklyRecords': weeklyRecords.map((r) => r.toJson()).toList(),
      'badges': badges.map((b) => b.toJson()).toList(),
      'pets': pets.map((p) => p.toJson()).toList(),
    };
  }
}
