// =============================================================================
// locked_overlay.dart - Kilitli içerik katmanı
// Onaylı olmayan kullanıcılar için içeriği bulanıklaştırıp üstüne
// "Uzman Onayı Gerekli" kartı koyar. Kilitli değilse içeriği aynen gösterir.
// =============================================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../app/theme/app_tokens.dart';

class LockedOverlay extends StatelessWidget {
  const LockedOverlay({
    super.key,
    required this.child,
    required this.isLocked,
    this.title = 'Uzman Onayı Gerekli',
    this.message = 'Bu özellikten faydalanabilmek için profilinizin uzman onayından geçmiş olması gerekir.',
    this.actionLabel = 'Onay İçin Başvur',
    this.onAction,
  });

  final Widget child;
  final bool isLocked;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    // Kilit yoksa hiçbir ek katman eklenmez.
    if (!isLocked) return child;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        // AbsorbPointer: alttaki içeriğe dokunmaları engeller (bulanık butonlara basılamaz).
        AbsorbPointer(
          absorbing: true,
          child: ImageFiltered(
            // İçeriği bulanıklaştırır; kullanıcı ne olduğunu sezer ama okuyamaz.
            imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: child,
          ),
        ),
        // Kilit kartı, Stack'in tamamını kaplayacak şekilde üste konur.
        Positioned.fill(
          child: Container(
            color: colorScheme.surface.withAlpha(160),
            alignment: Alignment.center,
            padding: AppSpacing.screenPadding,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        size: 40,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
                    if (onAction != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(
                        onPressed: onAction,
                        child: Text(actionLabel),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
