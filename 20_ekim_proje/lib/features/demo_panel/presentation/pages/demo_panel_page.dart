import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/demo/demo_settings_provider.dart';
import '../../../../core/models/models.dart';
import '../../../../core/session/session_provider.dart';

class DemoPanelPage extends ConsumerWidget {
  const DemoPanelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final user = session.user;
    final demoSettings = ref.watch(demoSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Demo & Simülasyon Paneli')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.md),
          const Text('Hazır Personalar', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              ActionChip(
                label: const Text('Girişimci (Onaysız & İş Plansız)'),
                onPressed: () {
                  ref.read(sessionProvider.notifier).login(
                    const AppUser(
                      id: 'usr_001',
                      name: 'Elif Karaca',
                      role: UserRole.entrepreneur,
                      email: 'elif@ornek.com',
                      city: 'İzmir',
                      bio: 'Tarımda sulama verimliliği.',
                      verificationStatus: VerificationStatus.notStarted,
                      hasBusinessPlan: false,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Persona: Elif Karaca (Onaysız/İş Plansız)')),
                  );
                },
              ),
              ActionChip(
                label: const Text('Girişimci (Onaylı & İş Planlı)'),
                onPressed: () {
                  ref.read(sessionProvider.notifier).login(
                    const AppUser(
                      id: 'usr_002',
                      name: 'Mert Özkan',
                      role: UserRole.entrepreneur,
                      email: 'mert@ornek.com',
                      city: 'İstanbul',
                      bio: 'KOBİ yapay zekâ ön muhasebe.',
                      verificationStatus: VerificationStatus.approved,
                      hasBusinessPlan: true,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Persona: Mert Özkan (Onaylı/İş Planlı)')),
                  );
                },
              ),
              ActionChip(
                label: const Text('Mentör (Ayşe Demirtaş)'),
                onPressed: () {
                  ref.read(sessionProvider.notifier).login(
                    const AppUser(
                      id: 'usr_003',
                      name: 'Ayşe Demirtaş',
                      role: UserRole.mentor,
                      email: 'ayse@ornek.com',
                      city: 'Ankara',
                      bio: 'Ürün ve pazar uyumu mentörü.',
                      verificationStatus: VerificationStatus.approved,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Persona: Ayşe Demirtaş (Mentör)')),
                  );
                },
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),
          const Text('Doğrulama & Onay Durumu', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          SegmentedButton<VerificationStatus>(
            segments: VerificationStatus.values.map((s) {
              return ButtonSegment(value: s, label: Text(s.label));
            }).toList(),
            selected: {user?.verificationStatus ?? VerificationStatus.notStarted},
            onSelectionChanged: (set) {
              final status = set.first;
              ref.read(sessionProvider.notifier).setVerificationStatus(
                status,
                rejectionReason: status == VerificationStatus.rejected ? 'Eksik vergi beyannamesi.' : null,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Durum: ${status.label} olarak ayarlandı.')),
              );
            },
          ),
          const Divider(height: AppSpacing.xl),
          const Text('İş Planı Durumu', style: TextStyle(fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('İş Planı Var (Sekmeleri değiştirir)'),
            value: user?.hasBusinessPlan ?? false,
            onChanged: (val) {
              ref.read(sessionProvider.notifier).setHasBusinessPlan(val);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('İş planı: ${val ? "Var" : "Yok"} yapıldı.')),
              );
            },
          ),
          const Divider(height: AppSpacing.xl),
          const Text('Ağ ve Hata Simülasyonu', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Text('Gecikme: '),
              ChoiceChip(
                label: const Text('0 ms'),
                selected: demoSettings.latency == Duration.zero,
                onSelected: (_) => ref.read(demoSettingsProvider.notifier).setLatency(Duration.zero),
              ),
              const SizedBox(width: AppSpacing.xs),
              ChoiceChip(
                label: const Text('600 ms'),
                selected: demoSettings.latency == const Duration(milliseconds: 600),
                onSelected: (_) => ref.read(demoSettingsProvider.notifier).setLatency(const Duration(milliseconds: 600)),
              ),
              const SizedBox(width: AppSpacing.xs),
              ChoiceChip(
                label: const Text('2000 ms'),
                selected: demoSettings.latency == const Duration(milliseconds: 2000),
                onSelected: (_) => ref.read(demoSettingsProvider.notifier).setLatency(const Duration(milliseconds: 2000)),
              ),
            ],
          ),
          SwitchListTile(
            title: const Text('Hata Simülasyonu Açık'),
            value: demoSettings.simulateErrors,
            onChanged: (val) {
              ref.read(demoSettingsProvider.notifier).setSimulateErrors(val);
            },
          ),
        ],
      ),
    );
  }
}
