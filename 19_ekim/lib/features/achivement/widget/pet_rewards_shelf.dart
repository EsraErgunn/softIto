// =============================================================================
// pet_rewards_shelf.dart - Evcil hayvan ödülleri vitrini (2 sütunlu ızgara)
// Açılmış bir pete dokununca kutlama penceresi (dialog) açılır.
// =============================================================================

import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/pet_reward.dart';

class PetRewardsShelf extends StatelessWidget {
  final List<PetReward> pets;

  const PetRewardsShelf({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    // GridView.builder: elemanları ızgara (grid) düzeninde dizer.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pets.length,
      // Sabit 2 sütun; childAspectRatio = genişlik / yükseklik oranı (1.15 -> hafif yatay kart).
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final pet = pets[index];
        return _PetCard(pet: pet);
      },
    );
  }
}

// Tek pet kartı: emoji, ad ve durum etiketi.
class _PetCard extends StatelessWidget {
  final PetReward pet;
  const _PetCard({required this.pet});

  // showDialog ile ekranın ortasında kutlama penceresi açar.
  void _showCelebration(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _PetDialog(pet: pet),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = pet.isUnlocked;

    return InkWell(
      // onTap null verilirse kart tıklanamaz olur; kilitli petlerde dialog açılmaz.
      onTap: isUnlocked ? () => _showCelebration(context) : null,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? AppColors.neonLime : AppColors.border,
            width: isUnlocked ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(pet.emoji, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 6),
            Text(pet.name, style: theme.textTheme.titleMedium?.copyWith(fontSize: 13)),
            const SizedBox(height: 2),
            _PetStatusBadge(pet: pet),
          ],
        ),
      ),
    );
  }
}

// Açıksa "Hediye Edildi", kilitliyse gereken XP miktarını gösterir.
class _PetStatusBadge extends StatelessWidget {
  final PetReward pet;
  const _PetStatusBadge({required this.pet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (pet.isUnlocked) {
      return Text('Hediye Edildi ✅', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.neonLime));
    }
    return Text('${pet.requiredPoints} XP', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textMuted));
  }
}

// Kutlama penceresi; "Harika!" butonu Navigator.pop ile pencereyi kapatır.
class _PetDialog extends StatelessWidget {
  final PetReward pet;
  const _PetDialog({required this.pet});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: AppColors.neonLime)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(pet.emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(pet.name, style: theme.textTheme.headlineMedium),
          Text(pet.title, style: theme.textTheme.titleMedium?.copyWith(color: AppColors.neonLime)),
          const SizedBox(height: 8),
          Text(pet.description, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Harika!')),
      ],
    );
  }
}
