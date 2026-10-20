import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/community_providers.dart';

class PostCard extends ConsumerStatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
  });

  final Post post;
  final VoidCallback? onTap;

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimController;
  late Animation<double> _likeScaleAnim;
  bool _showHeartPop = false;

  @override
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _likeScaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeAnimController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    super.dispose();
  }

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

  void _onDoubleTapLike() {
    final isLiked = ref.read(likedPostIdsProvider).contains(widget.post.id);
    if (!isLiked) {
      ref.read(likedPostIdsProvider.notifier).toggle(widget.post.id);
    }
    setState(() => _showHeartPop = true);
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showHeartPop = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLiked = ref.watch(likedPostIdsProvider).contains(widget.post.id);
    final isReposted = ref.watch(repostedPostIdsProvider).contains(widget.post.id);

    final displayLikes = widget.post.likeCount + (isLiked ? 1 : 0);
    final displayReposts = widget.post.repostCount + (isReposted ? 1 : 0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: widget.onTap ?? () => context.push('/community/post/${widget.post.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Avatar, Name, Role, Time
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context.push('/people/${widget.post.author.id}'),
                    child: VerifiedAvatar(
                      name: widget.post.author.name,
                      isVerified: widget.post.author.isVerified,
                      size: AvatarSize.md,
                      heroTag: 'author_${widget.post.author.id}_${widget.post.id}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.post.author.name,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(AppRadius.full),
                              ),
                              child: Text(
                                widget.post.author.role.label,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _formatTimeAgo(widget.post.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Content
              Text(
                widget.post.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                ),
              ),

              // Image (if any) with Double-Tap like animation
              if (widget.post.imageAsset != null) ...[
                const SizedBox(height: AppSpacing.md),
                GestureDetector(
                  onDoubleTap: _onDoubleTapLike,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.asset(
                            widget.post.imageAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      if (_showHeartPop)
                        AnimatedOpacity(
                          opacity: _showHeartPop ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            Icons.favorite,
                            size: 80,
                            color: Colors.white,
                            shadows: [
                              Shadow(color: Colors.black45, blurRadius: 16),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],

              // Tags
              if (widget.post.tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xxs,
                  children: widget.post.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        '#$tag',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: AppSpacing.sm),
              const Divider(height: 1),

              // Action Bar: Like, Repost, Comment, Share
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Like button
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      onTap: () {
                        _likeAnimController.forward(from: 0.0);
                        ref.read(likedPostIdsProvider.notifier).toggle(widget.post.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            ScaleTransition(
                              scale: _likeScaleAnim,
                              child: Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                size: 20,
                                color: isLiked ? Colors.pink : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '$displayLikes',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isLiked ? Colors.pink : colorScheme.onSurfaceVariant,
                                fontWeight: isLiked ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Repost / Retweet button
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      onTap: () {
                        ref.read(repostedPostIdsProvider.notifier).toggle(widget.post.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.repeat,
                              size: 20,
                              color: isReposted ? Colors.teal : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '$displayReposts',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: isReposted ? Colors.teal : colorScheme.onSurfaceVariant,
                                fontWeight: isReposted ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Comment button
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      onTap: () => context.push('/community/post/${widget.post.id}'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 19,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '${widget.post.commentCount}',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Share button
                    IconButton(
                      icon: Icon(Icons.share_outlined, size: 20, color: colorScheme.onSurfaceVariant),
                      tooltip: 'Paylaş',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Gönderi bağlantısı kopyalandı!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
