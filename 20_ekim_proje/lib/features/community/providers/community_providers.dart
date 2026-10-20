import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/storage/prefs_provider.dart';
import '../data/community_repository.dart';

const _kLikedPostsKey = 'app_liked_posts';
const _kRepostedPostsKey = 'app_reposted_posts';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return MockCommunityRepository(ref);
});

final postsProvider = FutureProvider<List<Post>>((ref) async {
  return ref.watch(communityRepositoryProvider).getPosts();
});

final postProvider = FutureProvider.family<Post, String>((ref, id) async {
  return ref.watch(communityRepositoryProvider).getPostById(id);
});

final commentsProvider = FutureProvider.family<List<Comment>, String>((ref, postId) async {
  return ref.watch(communityRepositoryProvider).getComments(postId);
});

class LikedPostIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final prefs = ref.watch(prefsProvider);
    final list = prefs.getStringList(_kLikedPostsKey) ?? [];
    return list.toSet();
  }

  Future<void> toggle(String postId) async {
    HapticFeedback.lightImpact();
    final current = {...state};
    if (current.contains(postId)) {
      current.remove(postId);
    } else {
      current.add(postId);
    }
    state = current;
    final prefs = ref.read(prefsProvider);
    await prefs.setStringList(_kLikedPostsKey, current.toList());
  }
}

final likedPostIdsProvider = NotifierProvider<LikedPostIdsNotifier, Set<String>>(
  LikedPostIdsNotifier.new,
);

class RepostedPostIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final prefs = ref.watch(prefsProvider);
    final list = prefs.getStringList(_kRepostedPostsKey) ?? [];
    return list.toSet();
  }

  Future<void> toggle(String postId) async {
    HapticFeedback.mediumImpact();
    final current = {...state};
    if (current.contains(postId)) {
      current.remove(postId);
    } else {
      current.add(postId);
    }
    state = current;
    final prefs = ref.read(prefsProvider);
    await prefs.setStringList(_kRepostedPostsKey, current.toList());
  }
}

final repostedPostIdsProvider = NotifierProvider<RepostedPostIdsNotifier, Set<String>>(
  RepostedPostIdsNotifier.new,
);
