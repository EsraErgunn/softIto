import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../directory/providers/directory_providers.dart';

class MentorDetailPage extends ConsumerWidget {
  const MentorDetailPage({super.key, required this.id});
  final String id;

  void _showMatchRequestDialog(BuildContext context, String mentorName) {
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
              '$mentorName ile Mentörlük Eşleşmesi',
              style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Girişiminiz ve mentörden hangi konularda rehberlik almak istediğinizi anlatan bir not yazın.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: noteController,
              maxLength: 300,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Hangi konuda mentörlük almak istiyorsunuz? (örn: Ürün fiyatlandırması, TÜBİTAK panel sunumu...)',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$mentorName için mentörlük eşleşme talebiniz iletildi!'),
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
    final mentorAsync = ref.watch(mentorProvider(id));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AsyncValueView<Mentor>(
      value: mentorAsync,
      data: (mentor) {
        return Scaffold(
          appBar: AppBar(title: Text(mentor.name)),
          body: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              const SizedBox(height: AppSpacing.md),
              Center(
                child: Column(
                  children: [
                    VerifiedAvatar(
                      name: mentor.name,
                      isVerified: mentor.isVerified,
                      size: AvatarSize.lg,
                      heroTag: 'avatar_${mentor.id}',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      mentor.name,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mentor.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${mentor.city} • ${mentor.yearsOfExperience} Yıllık Deneyim',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Bio
              const SectionHeader(title: 'Biyografi & Deneyim'),
              Text(mentor.bio, style: theme.textTheme.bodyMedium?.copyWith(height: 1.5)),
              const SizedBox(height: AppSpacing.lg),

              // Expertise Sectors
              if (mentor.expertise.isNotEmpty) ...[
                const SectionHeader(title: 'Uzmanlık Sektörleri'),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: mentor.expertise.map((s) => Chip(label: Text(s.label))).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Topics
              if (mentor.topics.isNotEmpty) ...[
                const SectionHeader(title: 'Rehberlik Konuları'),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: mentor.topics.map((t) {
                    return Chip(
                      avatar: const Icon(Icons.check, size: 16),
                      label: Text(t.label),
                      backgroundColor: colorScheme.primaryContainer.withAlpha(100),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Contact Info
              const SectionHeader(title: 'İletişim'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: Text(mentor.contact.email),
                        subtitle: const Text('Eşleşme sağlandığında doğrudan iletişime geçebilirsiniz.'),
                        dense: true,
                      ),
                      if (mentor.contact.linkedinUrl != null)
                        ListTile(
                          leading: const Icon(Icons.link),
                          title: const Text('LinkedIn Profili'),
                          subtitle: Text(mentor.contact.linkedinUrl!),
                          dense: true,
                        ),
                    ],
                  ),
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
              child: FilledButton.icon(
                icon: const Icon(Icons.handshake_outlined),
                label: const Text('Mentörlük Eşleşmesi İste'),
                onPressed: () => _showMatchRequestDialog(context, mentor.name),
              ),
            ),
          ),
        );
      },
    );
  }
}
