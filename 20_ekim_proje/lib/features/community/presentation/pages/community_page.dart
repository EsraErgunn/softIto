// =============================================================================
// community_page.dart - Topluluk akışı (gönderi listesi)
// Aşağı çekerek yenileme, yüklenirken iskelet, boşsa boş durum ve "Paylaş" butonu.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/community_providers.dart';
import '../widgets/post_card.dart';

class CommunityPage extends ConsumerWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValue<List<Post>>: yükleniyor / veri / hata durumlarından birini taşır.
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      body: RefreshIndicator(
        // Aşağı çekince (pull-to-refresh) provider geçersiz kılınır (invalidate);
        // bir sonraki okumada veri yeniden çekilir.
        onRefresh: () async {
          ref.invalidate(postsProvider);
        },
        // Üç durumu (loading/data/error) tek widget ile yönetir; bkz. core/widgets.
        child: AsyncValueView(
          value: postsAsync,
          loading: () => const SkeletonList(
            variant: SkeletonVariant.post,
            itemCount: 5,
          ),
          empty: (posts) => posts.isEmpty,
          emptyBuilder: () => EmptyState.posts(
            onAction: () => context.push('/community/new'),
          ),
          data: (posts) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: posts.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xxs),
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            );
          },
        ),
      ),
      // Sağ altta yazılı yüzen buton: yeni gönderi sayfasını açar.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/community/new'),
        icon: const Icon(Icons.edit),
        label: const Text('Paylaş'),
      ),
    );
  }
}
