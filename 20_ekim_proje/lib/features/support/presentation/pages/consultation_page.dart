import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/session/session_provider.dart';
import '../../../../core/widgets/widgets.dart';

class ConsultationPage extends ConsumerWidget {
  const ConsultationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApproved = ref.watch(isApprovedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ücretsiz Uzman Danışmanlığı')),
      body: LockedOverlay(
        isLocked: !isApproved,
        onAction: () => context.push('/verification'),
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Danışmanlık Almak İstediğiniz Alanı Seçin:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...ConsultantField.values.map(
              (f) => Card(
                child: ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: Text(f.label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${f.label} için randevu oluşturuluyor...')),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
