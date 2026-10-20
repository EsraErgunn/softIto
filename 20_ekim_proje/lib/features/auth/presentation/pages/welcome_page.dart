import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.rocket_launch, size: 72, color: colorScheme.primary),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Girişim Destek Platformu',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Fikrinizi şirkete, şirketinizi başarıya dönüştürün.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildValueProp(context, Icons.gavel_outlined, 'Hukuki ve Mali Güvence', 'Kuruluş, vergi ve SGK süreçlerinde uzman danışmanlık.'),
              const SizedBox(height: AppSpacing.md),
              _buildValueProp(context, Icons.handshake_outlined, 'Mentör & Yatırımcı Eşleşmesi', 'Alanında uzman liderlerle doğrudan bağlantı kurun.'),
              const SizedBox(height: AppSpacing.md),
              _buildValueProp(context, Icons.payments_outlined, 'Hibe ve Fon Takibi', 'TÜBİTAK, KOSGEB ve AB çağrılarını tek merkezden izleyin.'),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/role'),
                child: const Text('Başla'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueProp(BuildContext context, IconData icon, String title, String desc) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(desc, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}
