import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/achievement_model.dart';

/// Hediye Hayvan (Mascot) ve puan takip kartı - Tema duyarlı
class PetGiftCard extends StatelessWidget {
  final AchievementModel model;
  final ValueChanged<String> onSelectPet;

  const PetGiftCard({
    super.key,
    required this.model,
    required this.onSelectPet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? AppColors.surfaceCard;
    final borderColor = theme.dividerTheme.color ?? AppColors.surfaceBorder;

    final activePet = model.pets.firstWhere(
      (p) => p.id == model.activePetId,
      orElse: () => model.pets.first,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x15BD00FF),
            blurRadius: 24,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildActivePetHero(context, activePet),
          const SizedBox(height: 18),
          _buildPetList(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final badgeBg =
        isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.pets_rounded, color: AppColors.neonPurple, size: 20),
            const SizedBox(width: 8),
            Text(
              'Hediye Hayvan Dostun',
              style: TextStyle(
                color: titleColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.neonPurple.withAlpha(80)),
          ),
          child: Text(
            '${model.totalPoints} Puan',
            style: const TextStyle(
              color: AppColors.neonPurple,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivePetHero(BuildContext context, PetGiftItem pet) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final heroBg =
        isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: heroBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPurple.withAlpha(80)),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceCard : AppColors.lightSurfaceCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonPurple, width: 2),
            ),
            child: Center(
              child: Text(
                pet.emoji,
                style: const TextStyle(fontSize: 34),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      pet.name,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '(${pet.species})',
                      style: const TextStyle(
                        color: AppColors.waterPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  pet.description,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tüm Hediye Hayvanlar:',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: model.pets.map((pet) {
            final isSelected = pet.id == model.activePetId;
            return _PetMiniCard(
              pet: pet,
              isSelected: isSelected,
              onTap: () => onSelectPet(pet.id),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PetMiniCard extends StatelessWidget {
  final PetGiftItem pet;
  final bool isSelected;
  final VoidCallback onTap;

  const _PetMiniCard({
    required this.pet,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceCard : AppColors.lightSurfaceCard;
    final selBg = isDark ? AppColors.surfaceElevated : AppColors.lightSurfaceElevated;
    final border = isDark ? AppColors.surfaceBorder : AppColors.lightSurfaceBorder;
    final titleColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;

    return GestureDetector(
      onTap: pet.isUnlocked ? onTap : null,
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? selBg : cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.neonPurple
                : (pet.isUnlocked ? border : border.withAlpha(50)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Opacity(
              opacity: pet.isUnlocked ? 1.0 : 0.4,
              child: Text(pet.emoji, style: const TextStyle(fontSize: 26)),
            ),
            const SizedBox(height: 4),
            Text(
              pet.name,
              style: TextStyle(
                color: pet.isUnlocked ? titleColor : AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              pet.isUnlocked ? 'Kazanıldı' : '${pet.requiredPoints} P',
              style: TextStyle(
                color: pet.isUnlocked ? AppColors.neonLimeDim : AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
