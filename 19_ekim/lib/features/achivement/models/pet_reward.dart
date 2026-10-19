import 'package:flutter/foundation.dart';

@immutable
class PetReward {
  final String id;
  final String name;
  final String emoji;
  final String title;
  final int requiredPoints;
  final String description;
  final bool isUnlocked;

  const PetReward({
    required this.id,
    required this.name,
    required this.emoji,
    required this.title,
    required this.requiredPoints,
    required this.description,
    this.isUnlocked = false,
  });

  PetReward copyWith({bool? isUnlocked}) {
    return PetReward(
      id: id,
      name: name,
      emoji: emoji,
      title: title,
      requiredPoints: requiredPoints,
      description: description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
