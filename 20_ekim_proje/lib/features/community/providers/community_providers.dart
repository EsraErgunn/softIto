// =============================================================================
// community_providers.dart - Topluluk özelliğinin Riverpod provider'ları
// =============================================================================

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/storage/prefs_provider.dart';
import '../data/community_repository.dart';

const _kLikedPostsKey = 'app_liked_posts';
const _kRepostedPostsKey = 'app_reposted_posts';

// Hangi repository'nin kullanılacağı tek yerden belirlenir (şu an Mock).
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return MockCommunityRepository(ref);
});

// FutureProvider: asenkron veriyi AsyncValue (loading/data/error) olarak sunar.
final postsProvider = FutureProvider<List<Post>>((ref) async {
  return ref.watch(communityRepositoryProvider).getPosts();
});

// .family: parametreli provider. postProvider('pst_1') gibi her id için ayrı sonuç tutulur.
final postProvider = FutureProvider.family<Post, String>((ref, id) async {
  return ref.watch(communityRepositoryProvider).getPostById(id);
});

final commentsProvider = FutureProvider.family<List<Comment>, String>((ref, postId) async {
  return ref.watch(communityRepositoryProvider).getComments(postId);
});

// Beğenilen gönderi id'leri. Set kullanılır: aynı id iki kez eklenemez, arama hızlıdır.
// Cihaza kaydedildiği için uygulama yeniden açılınca beğeniler korunur.
class LikedPostIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final prefs = ref.watch(prefsProvider);
    final list = prefs.getStringList(_kLikedPostsKey) ?? [];
    return list.toSet();
  }

  Future<void> toggle(String postId) async {
    // Beğenide telefona hafif titreşim geri bildirimi.
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

// Yeniden paylaşılan gönderi id'leri (beğeni ile aynı mantık).
class RepostedPostIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final prefs = ref.watch(prefsProvider);
    final list = prefs.getStringList(_kRepostedPostsKey) ?? [];
    return list.toSet();
  }

  Future<void> toggle(String postId) async {
    // Yeniden paylaşımda (repost) biraz daha güçlü titreşim.
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
