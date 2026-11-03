// =============================================================================
// status_badge.dart - Durum rozeti (Doğrulandı, Bekliyor, Reddedildi, X gün kaldı ...)
// Renkler temadaki StatusColors uzantısından gelir; açık/koyu temaya uyumludur.
// =============================================================================

import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_tokens.dart';
import '../models/enums.dart';

// Rozetin renk tonu.
enum StatusBadgeTone { approved, pending, rejected, info, neutral }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.icon,
    this.tone = StatusBadgeTone.neutral,
  });

  final String label;
  final IconData icon;
  final StatusBadgeTone tone;

  // Doğrulama durumunu uygun etiket/ikon/renkli rozete çevirir.
  factory StatusBadge.verification(VerificationStatus status) {
    return switch (status) {
      VerificationStatus.approved => const StatusBadge(
          label: 'Doğrulandı',
          icon: Icons.check_circle_outline,
          tone: StatusBadgeTone.approved,
        ),
      VerificationStatus.pending => const StatusBadge(
          label: 'İncelemede',
          icon: Icons.hourglass_top,
          tone: StatusBadgeTone.pending,
        ),
      VerificationStatus.rejected => const StatusBadge(
          label: 'Reddedildi',
          icon: Icons.cancel_outlined,
          tone: StatusBadgeTone.rejected,
        ),
      VerificationStatus.notStarted => const StatusBadge(
          label: 'Onaysız',
          icon: Icons.shield_outlined,
          tone: StatusBadgeTone.neutral,
        ),
    };
  }

  // Eşleşme durumunu rozete çevirir.
  factory StatusBadge.match(MatchStatus status) {
    return switch (status) {
      MatchStatus.accepted => const StatusBadge(
          label: 'Eşleşildi',
          icon: Icons.check,
          tone: StatusBadgeTone.approved,
        ),
      MatchStatus.pending => const StatusBadge(
          label: 'Bekliyor',
          icon: Icons.schedule,
          tone: StatusBadgeTone.pending,
        ),
      MatchStatus.rejected => const StatusBadge(
          label: 'Reddedildi',
          icon: Icons.close,
          tone: StatusBadgeTone.rejected,
        ),
      MatchStatus.none => const StatusBadge(
          label: 'Eşleşme Yok',
          icon: Icons.person_add_outlined,
          tone: StatusBadgeTone.neutral,
        ),
    };
  }

  // Son başvuru tarihine kalan güne göre: geçmişse kırmızı, 7 gün veya azsa turuncu, değilse mavi.
  factory StatusBadge.deadline(int daysLeft) {
    if (daysLeft < 0) {
      return const StatusBadge(
        label: 'Süresi Doldu',
        icon: Icons.event_busy,
        tone: StatusBadgeTone.rejected,
      );
    } else if (daysLeft <= 7) {
      return StatusBadge(
        label: '$daysLeft gün kaldı',
        icon: Icons.alarm,
        tone: StatusBadgeTone.pending,
      );
    } else {
      return StatusBadge(
        label: '$daysLeft gün kaldı',
        icon: Icons.calendar_today_outlined,
        tone: StatusBadgeTone.info,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Temadan özel durum renkleri alınır; tanımlı değilse açık tema renkleri kullanılır.
    final statusColors = theme.extension<StatusColors>() ?? StatusColors.light;

    // Dart 3 record + destructuring: switch iki renk birden döner ve bg / fg değişkenlerine açılır.
    final (Color bg, Color fg) = switch (tone) {
      StatusBadgeTone.approved => (statusColors.approvedContainer, statusColors.onApprovedContainer),
      StatusBadgeTone.pending => (statusColors.pendingContainer, statusColors.onPendingContainer),
      StatusBadgeTone.rejected => (statusColors.rejectedContainer, statusColors.onRejectedContainer),
      StatusBadgeTone.info => (statusColors.infoContainer, statusColors.onInfoContainer),
      StatusBadgeTone.neutral => (statusColors.neutralContainer, statusColors.onNeutralContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
