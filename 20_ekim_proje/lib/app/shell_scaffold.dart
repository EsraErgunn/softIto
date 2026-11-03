// =============================================================================
// shell_scaffold.dart - Alt menülü ana iskelet (AppBar + içerik + NavigationBar)
// StatefulShellRoute tarafından her sekmede bu iskelet kullanılır.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/session/session_provider.dart';
import '../core/widgets/verified_avatar.dart';

class ShellScaffold extends ConsumerWidget {
  const ShellScaffold({
    super.key,
    required this.navigationShell,
  });

  // GoRouter'ın verdiği nesne: aktif sekmenin index'i ve içeriği (body) bunun içinde.
  final StatefulNavigationShell navigationShell;

  // Aktif sekmeye göre AppBar başlığı.
  String _getTitle(int index) {
    return switch (index) {
      0 => 'Mentörler',
      1 => 'Yatırımcılar',
      2 => 'Programlar',
      3 => 'Topluluk',
      _ => 'Girişim Destek',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Oturum değişirse (ör. isim/onay durumu) AppBar'daki avatar güncellenir.
    final session = ref.watch(sessionProvider);
    final user = session.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(navigationShell.currentIndex)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              // push: profili mevcut sayfanın ÜSTÜNE açar (geri tuşuyla dönülebilir).
              onTap: () => context.push('/profile'),
              child: VerifiedAvatar(
                name: user?.name ?? 'Misafir',
                // Hesap onaylıysa avatarda doğrulama rozeti gösterilir.
                isVerified: ref.watch(isApprovedProvider),
                size: AvatarSize.sm,
              ),
            ),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          // Seçilen sekmeye geçer. Zaten açık sekmeye tekrar basılırsa (initialLocation: true)
          // o sekmenin başlangıç sayfasına geri döner.
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Mentörler',
          ),
          NavigationDestination(
            icon: Icon(Icons.monetization_on_outlined),
            selectedIcon: Icon(Icons.monetization_on),
            label: 'Yatırımcılar',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Programlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum),
            label: 'Topluluk',
          ),
        ],
      ),
    );
  }
}
