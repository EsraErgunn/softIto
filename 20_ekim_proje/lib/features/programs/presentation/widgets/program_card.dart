import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/programs_providers.dart';

class ProgramCard extends ConsumerWidget {
  const ProgramCard({
    super.key,
    required this.program,
    this.onTap,
  });

  final Program program;
  final VoidCallback? onTap;

  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      final m = amount / 1000000;
      return '₺${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)} Milyon';
    } else if (amount >= 1000) {
      return '₺${(amount ~/ 1000)}.000';
    }
    return '₺$amount';
  }

  int _calculateDaysLeft(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSaved = ref.watch(savedProgramIdsProvider).contains(program.id);
    final daysLeft = _calculateDaysLeft(program.deadline);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Type, Scope, Verification Req, Bookmark
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      program.type.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      program.scope == ProgramScope.international
                          ? (program.country != null ? '🌍 ${program.country}' : '🌍 Yurt Dışı')
                          : '🇹🇷 Yurt İçi',
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 11),
                    ),
                  ),
                  if (program.requiresVerification) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer.withAlpha(120),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        'Onay Gerekli',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => ref.read(savedProgramIdsProvider.notifier).toggle(program.id),
                    tooltip: isSaved ? 'Kaydedilenlerden Çıkar' : 'Kaydet',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              // Title & Provider
              Text(
                program.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                program.provider,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Summary
              Text(
                program.summary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),

              // Bottom Row: Max Amount and Deadline Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payments_outlined, size: 18, color: colorScheme.secondary),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${_formatAmount(program.amountMax)}\'ye kadar',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  StatusBadge.deadline(daysLeft),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
