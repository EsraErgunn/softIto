import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/session/session_provider.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Girişim Onboarding')),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.description_outlined, size: 64),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Hazır bir iş planın var mı?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonal(
                onPressed: () async {
                  await ref.read(sessionProvider.notifier).setHasBusinessPlan(true);
                  await ref.read(sessionProvider.notifier).setOnboardingDone(true);
                  if (context.mounted) context.go('/mentors');
                },
                child: const Text('Evet, İş Planım Var'),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton(
                onPressed: () async {
                  await ref.read(sessionProvider.notifier).setHasBusinessPlan(false);
                  await ref.read(sessionProvider.notifier).setOnboardingDone(true);
                  if (context.mounted) context.go('/mentors');
                },
                child: const Text('Hayır, Henüz Yok'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
