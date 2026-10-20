import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../directory/providers/directory_providers.dart';

class InvestorDetailPage extends ConsumerWidget {
  const InvestorDetailPage({super.key, required this.id});
  final String id;

  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      final m = amount / 1000000;
      return '₺${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)}M';
    } else if (amount >= 1000) {
      return '₺${(amount ~/ 1000)}B';
    }
    return '₺$amount';
  }

  void _showMatchRequestDialog(BuildContext context, String investorName) {
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$investorName ile Eşleşme İste',
              style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Girişiminiz, aradığınız yatırım tutarı ve neden bu yatırımcıyı seçtiğinizi anlatan kısa bir not ekleyin (maks. 300 karakter).',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: noteController,
              maxLength: 300,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Merhaba, yapay zekâ ön muhasebe SaaS girişimimiz için tohum yatırım arıyoruz...',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$investorName için eşleşme talebiniz iletildi! Durumu Profil > Eşleşmelerim\'den takip edebilirsiniz.'),
                  ),
                );
              },
              child: const Text('Talebi Gönder'),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investorAsync = ref.watch(investorProvider(id));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AsyncValueView<Investor>(
      value: investorAsync,
      data: (investor) {
        return Scaffold(
          appBar: AppBar(title: Text(investor.name)),
          body: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Column(
                  children: [
                    VerifiedAvatar(
                      name: investor.name,
                      isVerified: investor.isVerified,
                      size: AvatarSize.lg,
                      heroTag: 'avatar_${investor.id}',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      investor.name,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      investor.firm,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${investor.city} • ${investor.investorType.label}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Ticket Size Card
              Card(
                color: colorScheme.secondaryContainer.withAlpha(90),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(Icons.payments_outlined, size: 32, color: colorScheme.onSecondaryContainer),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yatırım Bilet Aralığı',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                          Text(
                            '${_formatCurrency(investor.ticketMin)} – ${_formatCurrency(investor.ticketMax)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Bio
              const SectionHeader(title: 'Hakkında'),
              Text(investor.bio, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
              const SizedBox(height: AppSpacing.lg),

              // Investment Thesis
              if (investor.thesis != null) ...[
                const SectionHeader(title: 'Yatırım Tezi'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline, color: colorScheme.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            investor.thesis!,
                            style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Portfolio
              if (investor.portfolio.isNotEmpty) ...[
                const SectionHeader(title: 'Portföy Girişimleri'),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: investor.portfolio.map((item) {
                    return Chip(
                      avatar: const Icon(Icons.rocket_outlined, size: 16),
                      label: Text(item),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Sectors & Stages
              const SectionHeader(title: 'Odak Sektörler & Aşamalar'),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  ...investor.sectors.map((s) => Chip(label: Text(s.label))),
                  ...investor.stages.map((st) => Chip(
                        label: Text(st.label),
                        backgroundColor: colorScheme.surfaceContainerHighest,
                      )),
                ],
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
              child: FilledButton.icon(
                icon: const Icon(Icons.handshake_outlined),
                label: const Text('Eşleşme İste'),
                onPressed: () => _showMatchRequestDialog(context, investor.name),
              ),
            ),
          ),
        );
      },
    );
  }
}
