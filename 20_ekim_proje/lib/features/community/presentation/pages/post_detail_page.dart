// =============================================================================
// post_detail_page.dart - Gönderi detayı ve yorumlar
// Üstte gönderi kartı, altında yorum listesi, en altta sabit yorum yazma çubuğu.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/session/session_provider.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/community_providers.dart';
import '../widgets/post_card.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({super.key, required this.id});
  final String id;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final _commentController = TextEditingController();
  // Yorum gönderilirken true; butonda spinner gösterilir ve çift gönderim engellenir.
  bool _isSending = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Tarihi "5 dk önce", "3 saat önce", "2 gün önce" biçimine çevirir.
  // clamp(1, 60): az önce yazılan yorum "0 dk önce" yerine "1 dk önce" görünür.
  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes.clamp(1, 60)} dk önce';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} saat önce';
    } else {
      return '${diff.inDays} gün önce';
    }
  }

  // Yorum gönderir; boşsa veya zaten gönderiliyorsa hiçbir şey yapmaz.
  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      final user = ref.read(sessionProvider).user;
      // Oturumdaki kullanıcıdan yorum yazarı bilgisi oluşturulur (giriş yoksa misafir değerleri).
      final author = PostAuthor(
        id: user?.id ?? 'usr_guest',
        name: user?.name ?? 'Girişimci',
        role: user?.role ?? UserRole.entrepreneur,
        isVerified: ref.read(isApprovedProvider),
      );

      await ref.read(communityRepositoryProvider).addComment(
            postId: widget.id,
            content: text,
            author: author,
          );

      _commentController.clear();
      // Yorum listesi ve gönderi (yorum sayısı) yeniden yüklenir; ekran güncellenir.
      ref.invalidate(commentsProvider(widget.id));
      ref.invalidate(postProvider(widget.id));
    // finally: hata olsa da olmasa da çalışır; yükleniyor durumu her koşulda kapatılır.
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // family provider'lar id parametresiyle çağrılır.
    final postAsync = ref.watch(postProvider(widget.id));
    final commentsAsync = ref.watch(commentsProvider(widget.id));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Gönderi & Yorumlar')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                AsyncValueView(
                  value: postAsync,
                  data: (post) => PostCard(post: post),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    'Yorumlar',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AsyncValueView(
                  value: commentsAsync,
                  loading: () => const SkeletonList(variant: SkeletonVariant.tile, itemCount: 3),
                  empty: (comments) => comments.isEmpty,
                  emptyBuilder: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Center(
                      child: Text('Henüz yorum yapılmamış. İlk yorumu sen yaz!'),
                    ),
                  ),
                  data: (comments) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      itemCount: comments.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerifiedAvatar(
                                name: comment.author.name,
                                isVerified: comment.author.isVerified,
                                size: AvatarSize.sm,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          comment.author.name,
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        Text(
                                          '• ${_formatTimeAgo(comment.createdAt)}',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      comment.content,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          // SafeArea: çentik / alt gezinme çubuğu altında kalmaması için.
          // Bottom comment input bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Bir yorum yazın...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _isSending
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(Icons.send, color: colorScheme.primary),
                    onPressed: _sendComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
