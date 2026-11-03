// =============================================================================
// profile_dashboard_page.dart - Profil paneli
// Kullanıcı özeti (avatar, ad, e-posta, doğrulama rozeti) ve tüm kişisel
// sayfalara giden menü: düzenle, doğrulama, girişimim, eşleşmeler, destekler, demo, çıkış.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/session/session_provider.dart';
import '../../../../core/widgets/widgets.dart';

class ProfileDashboardPage extends ConsumerWidget {
  const ProfileDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Oturum değişince (ör. doğrulama durumu) panel otomatik güncellenir.
    final session = ref.watch(sessionProvider);
    final user = session.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim & Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Column(
              children: [
                VerifiedAvatar(
                  name: user?.name ?? 'Kullanıcı',
                  isVerified: ref.watch(isApprovedProvider),
                  size: AvatarSize.lg,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  user?.name ?? 'Giriş Yapılmadı',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                // Doğrulama durumuna göre renkli rozet.
                StatusBadge.verification(user?.verificationStatus ?? VerificationStatus.notStarted),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Profili Düzenle'),
            trailing: const Icon(Icons.chevron_right),
            // Her satır ilgili sayfayı mevcut sayfanın üstüne açar (geri tuşuyla dönülür).
            onTap: () => context.push('/profile/edit'),
          ),
          ListTile(
            leading: const Icon(Icons.verified_user_outlined),
            title: const Text('Uzman Onayı & Belgeler'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/verification'),
          ),
          ListTile(
            leading: const Icon(Icons.rocket_launch_outlined),
            title: const Text('Girişimim & Yol Haritası'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/profile/startup'),
          ),
          ListTile(
            leading: const Icon(Icons.handshake_outlined),
            title: const Text('Eşleşmelerim'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/matches'),
          ),
          ListTile(
            leading: const Icon(Icons.monetization_on_outlined),
            title: const Text('Maddi Destek Başvurusu'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/support/funding'),
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text('Ücretsiz Uzman Danışmanlığı'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/support/consultation'),
          ),
          ListTile(
            leading: const Icon(Icons.developer_mode_outlined),
            title: const Text('Demo Paneli'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/demo'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
            onTap: () async {
              // Çıkışta oturum temizlenir; router da kullanıcıyı giriş sayfalarına yönlendirir.
              await ref.read(sessionProvider.notifier).logout();
              if (context.mounted) context.go('/welcome');
            },
          ),
        ],
      ),
    );
  }
}
