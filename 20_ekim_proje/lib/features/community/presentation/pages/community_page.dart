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
    final postsAsync = ref.watch(postsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(postsProvider);
        },
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/community/new'),
        icon: const Icon(Icons.edit),
        label: const Text('Paylaş'),
      ),
    );
  }
}
