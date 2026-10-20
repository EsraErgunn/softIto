import 'package:flutter/material.dart';
import '../../app/theme/app_tokens.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  factory EmptyState.mentors({VoidCallback? onAction}) => EmptyState(
        icon: Icons.person_search_outlined,
        title: 'Henüz Mentör Bulunamadı',
        message: 'Kriterlerine uygun mentörler sisteme eklendiğinde burada listelenecektir.',
        actionLabel: onAction != null ? 'Filtreleri Temizle' : null,
        onAction: onAction,
      );

  factory EmptyState.investors({VoidCallback? onAction}) => EmptyState(
        icon: Icons.savings_outlined,
        title: 'Henüz Yatırımcı Bulunamadı',
        message: 'Arama kriterlerine uygun yatırımcı bulunamadı.',
        actionLabel: onAction != null ? 'Filtreleri Temizle' : null,
        onAction: onAction,
      );

  factory EmptyState.programs({VoidCallback? onAction}) => EmptyState(
        icon: Icons.campaign_outlined,
        title: 'Uygun Program Bulunamadı',
        message: 'Seçilen kriterlerde aktif destek veya hibe programı bulunamadı.',
        actionLabel: onAction != null ? 'Tüm Programları Gör' : null,
        onAction: onAction,
      );

  factory EmptyState.posts({VoidCallback? onAction}) => EmptyState(
        icon: Icons.forum_outlined,
        title: 'Henüz Gönderi Paylaşılmadı',
        message: 'Toplulukta ilk paylaşımı sen yaparak tartışmayı başlatabilirsin!',
        actionLabel: onAction != null ? 'Gönderi Paylaş' : null,
        onAction: onAction,
      );

  factory EmptyState.matches({VoidCallback? onAction}) => EmptyState(
        icon: Icons.handshake_outlined,
        title: 'Henüz Eşleşme İsteğin Yok',
        message: 'Mentör ve yatırımcı listesini inceleyip hemen ilk eşleşme talebini gönderebilirsin.',
        actionLabel: onAction != null ? 'Mentörleri İncele' : null,
        onAction: onAction,
      );

  factory EmptyState.filtered(VoidCallback onClear) => EmptyState(
        icon: Icons.filter_alt_off_outlined,
        title: 'Sonuç Bulunamadı',
        message: 'Filtrelerini değiştirerek veya temizleyerek tekrar dene.',
        actionLabel: 'Filtreleri Temizle',
        onAction: onClear,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: AppSpacing.lg),
                FilledButton.tonal(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
