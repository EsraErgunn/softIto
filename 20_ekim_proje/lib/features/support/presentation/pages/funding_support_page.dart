import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/session/session_provider.dart';
import '../../../../core/widgets/widgets.dart';

class FundingSupportPage extends ConsumerWidget {
  const FundingSupportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApproved = ref.watch(isApprovedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Maddi Destek Başvurusu')),
      body: LockedOverlay(
        isLocked: !isApproved,
        onAction: () => context.push('/verification'),
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Onaylı Girişimci Hibe Havuzu', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: AppSpacing.xs),
                      Text('Platform üzerinden onaylanmış girişimcilere ₺100.000\'ye kadar nakdi destek sunulmaktadır.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Talep Edilen Tutar (₺)'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Kullanım Amacı ve Bütçe Planı'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Maddi destek başvurunuz alındı.')),
                  );
                },
                child: const Text('Başvuruyu Tamamla'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
