import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/session/session_provider.dart';
import '../../../../core/widgets/widgets.dart';

class VerificationPage extends ConsumerWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final status = session.user?.verificationStatus ?? VerificationStatus.notStarted;

    return Scaffold(
      appBar: AppBar(title: const Text('Uzman Onayı & Doğrulama')),
      body: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    const Text('Mevcut Doğrulama Durumu', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.sm),
                    StatusBadge.verification(status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Gerekli Belgeler:'),
            const SizedBox(height: AppSpacing.sm),
            const ListTile(
              leading: Icon(Icons.picture_as_pdf_outlined),
              title: Text('Kimlik / İmza Sirküleri'),
              subtitle: Text('PDF veya görsel'),
            ),
            const ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('İş Planı / Pitch Deck'),
              subtitle: Text('Girişim özeti'),
            ),
            const Spacer(),
            if (status != VerificationStatus.approved)
              FilledButton(
                onPressed: () {
                  ref.read(sessionProvider.notifier).submitVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Başvurunuz incelemeye alındı.')),
                  );
                },
                child: const Text('Onay İçin Başvuruyu Gönder'),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
