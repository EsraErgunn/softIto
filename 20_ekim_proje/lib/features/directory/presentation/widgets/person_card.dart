import 'package:flutter/material.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({
    super.key,
    required this.profile,
    this.onTap,
  });

  final DirectoryProfile profile;
  final VoidCallback? onTap;

  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      final m = amount / 1000000;
      return '₺${m.toStringAsFixed(m.truncateToDouble() == m ? 0 : 1)}M';
    } else if (amount >= 1000) {
      return '₺${(amount ~/ 1000)}B';
    }
    return '₺$amount';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (profile is Investor) {
      final inv = profile as Investor;
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerifiedAvatar(
                      name: inv.name,
                      isVerified: inv.isVerified,
                      size: AvatarSize.md,
                      heroTag: 'avatar_${inv.id}',
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  inv.name,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(
                                  inv.investorType.label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 10,
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            inv.firm,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            inv.city,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  inv.bio,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Ticket Range & Portfolio
                Row(
                  children: [
                    Icon(Icons.monetization_on_outlined, size: 16, color: colorScheme.secondary),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      'Bilet: ${_formatCurrency(inv.ticketMin)} – ${_formatCurrency(inv.ticketMax)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),

                if (inv.portfolio.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Portföy: ${inv.portfolio.join(', ')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: AppSpacing.sm),
                // Sectors
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xxs,
                  children: inv.sectors.take(3).map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        s.label,
                        style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      final mentor = profile as Mentor;
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerifiedAvatar(
                  name: mentor.name,
                  isVerified: mentor.isVerified,
                  size: AvatarSize.md,
                  heroTag: 'avatar_${mentor.id}',
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mentor.name,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        mentor.title,
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.primary),
                      ),
                      Text(
                        mentor.city,
                        style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        mentor.bio,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
