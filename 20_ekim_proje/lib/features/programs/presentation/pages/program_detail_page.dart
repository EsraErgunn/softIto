// =============================================================================
// program_detail_page.dart - Destek programı detay sayfası
// Tür/kapsam etiketleri, kalan gün rozeti, maksimum tutar, özet, başvuru koşulları,
// hedef aşamalar ve altta başvuru butonu. Onay gerektiren programlarda onaysız
// kullanıcıya "Uzman Onayı Gerekli" butonu gösterilir.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/session/session_provider.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/programs_providers.dart';

class ProgramDetailPage extends ConsumerWidget {
  const ProgramDetailPage({super.key, required this.id});
  final String id;

  // Tutarı okunur yazar: 5.000.000 -> "₺5 Milyon", 250.000 -> "₺250.000".
  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      final m = amount / 1000000;
      return '₺${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)} Milyon';
    } else if (amount >= 1000) {
      return '₺${(amount ~/ 1000)}.000';
    }
    return '₺$amount';
  }

  // Bugünün gece yarısı baz alınarak son başvuru tarihine kalan gün; geçmişse negatif.
  int _calculateDaysLeft(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programProvider(id));
    final isApproved = ref.watch(isApprovedProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AsyncValueView<Program>(
      value: programAsync,
      data: (program) {
        final daysLeft = _calculateDaysLeft(program.deadline);
        // Program onay istiyorsa ve kullanıcı onaylı değilse başvuru kilitlidir.
        final isLocked = program.requiresVerification && !isApproved;

        return Scaffold(
          appBar: AppBar(
            title: Text(program.provider),
            actions: [
              // Consumer: sayfanın sadece bu küçük kısmını (kaydet ikonu) provider'a bağlar;
              // kaydet'e basınca tüm sayfa değil sadece ikon yeniden çizilir.
              Consumer(builder: (context, ref, _) {
                final isSaved = ref.watch(savedProgramIdsProvider).contains(program.id);
                return IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? colorScheme.primary : null,
                  ),
                  onPressed: () => ref.read(savedProgramIdsProvider.notifier).toggle(program.id),
                );
              }),
            ],
          ),
          body: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              const SizedBox(height: AppSpacing.sm),
              // Type & Scope Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      program.type.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      // Yurt dışı programlarda ülke adı (varsa) gösterilir.
                      program.scope == ProgramScope.international
                          ? (program.country != null ? '🌍 ${program.country}' : '🌍 Yurt Dışı')
                          : '🇹🇷 Yurt İçi',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  const Spacer(),
                  StatusBadge.deadline(daysLeft),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Title
              Text(
                program.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                program.provider,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Max Amount Card
              Card(
                color: colorScheme.primaryContainer.withAlpha(90),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(Icons.monetization_on_outlined, size: 36, color: colorScheme.primary),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Maksimum Hibe / Destek Tutarı', style: theme.textTheme.labelMedium),
                          Text(
                            _formatAmount(program.amountMax),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Summary
              const SectionHeader(title: 'Program Özeti'),
              Text(program.summary, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
              const SizedBox(height: AppSpacing.lg),

              // Eligibility
              if (program.eligibility.isNotEmpty) ...[
                const SectionHeader(title: 'Başvuru Koşulları'),
                // Her başvuru koşulu tikli bir satır olarak listelenir.
                ...program.eligibility.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline, size: 18, color: colorScheme.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: Text(item, style: theme.textTheme.bodyMedium)),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Target Stages
              if (program.targetStages.isNotEmpty) ...[
                const SectionHeader(title: 'Hedef Girişim Aşamaları'),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: program.targetStages.map((s) {
                    return Chip(
                      label: Text(s.label),
                      backgroundColor: colorScheme.surfaceContainerHigh,
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Tags
              if (program.tags.isNotEmpty) ...[
                Wrap(
                  spacing: AppSpacing.xs,
                  children: program.tags.map((t) => Text('#$t', style: TextStyle(color: colorScheme.primary))).toList(),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Demo Notice
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  'Not: Demo veridir, güncel koşullar ve resmî çağrı metni için ilgili kurumun resmî web sitesini kontrol ediniz.',
                  style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
              ),
              // Kilitliyse doğrulama sayfasına yönlendiren buton, değilse "Başvuru Yap" (demo: bilgi mesajı).
              child: isLocked
                  ? OutlinedButton.icon(
                      icon: const Icon(Icons.lock_outline),
                      label: const Text('Bu Çağrı İçin Uzman Onayı Gerekli'),
                      onPressed: () => context.push('/verification'),
                    )
                  : FilledButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Başvuru Yap'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${program.title} için başvuru portalı açılıyor...'),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
