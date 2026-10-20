import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/demo/demo_settings_provider.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/date_resolver.dart';

abstract class CommunityRepository {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(String id);
  Future<List<Comment>> getComments(String postId);
  Future<Comment> addComment({
    required String postId,
    required String content,
    required PostAuthor author,
  });
  Future<Post> createPost({
    required String content,
    required List<String> tags,
    String? imageAsset,
    required PostAuthor author,
  });
}

class MockCommunityRepository implements CommunityRepository {
  MockCommunityRepository(this._ref);
  final Ref _ref;

  List<Post>? _posts;
  List<Comment>? _comments;

  Future<void> _simulateNetwork() async {
    final demo = _ref.read(demoSettingsProvider);
    if (demo.latency > Duration.zero) {
      await Future.delayed(demo.latency);
    }
    if (demo.simulateErrors) {
      throw const AppException('Topluluk verileri yüklenirken bağlantı hatası oluştu.');
    }
  }

  @override
  Future<List<Post>> getPosts() async {
    await _simulateNetwork();
    if (_posts != null) return _posts!;

    final raw = await rootBundle.loadString('assets/mock/posts.json');
    final now = DateTime.now();
    final list = (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map((j) => resolveRelativeDates(j, now))
        .map((j) => Post.fromJson(j))
        .toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _posts = list;
    return _posts!;
  }

  @override
  Future<Post> getPostById(String id) async {
    final posts = await getPosts();
    return posts.firstWhere(
      (p) => p.id == id,
      orElse: () => throw AppException('Gönderi bulunamadı: $id'),
    );
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    await _simulateNetwork();
    if (_comments == null) {
      final raw = await rootBundle.loadString('assets/mock/comments.json');
      final now = DateTime.now();
      _comments = (jsonDecode(raw) as List)
          .cast<Map<String, dynamic>>()
          .map((j) => resolveRelativeDates(j, now))
          .map((j) => Comment.fromJson(j))
          .toList();
    }

    final postComments = _comments!.where((c) => c.postId == postId).toList();
    postComments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return postComments;
  }

  @override
  Future<Comment> addComment({
    required String postId,
    required String content,
    required PostAuthor author,
  }) async {
    await _simulateNetwork();
    final newComment = Comment(
      id: 'cmt_${DateTime.now().millisecondsSinceEpoch}',
      postId: postId,
      author: author,
      content: content,
      createdAt: DateTime.now(),
    );

    _comments = [...?_comments, newComment];

    // Gönderideki commentCount'u 1 artır
    if (_posts != null) {
      _posts = _posts!.map((p) {
        if (p.id == postId) {
          return p.copyWith(commentCount: p.commentCount + 1);
        }
        return p;
      }).toList();
    }

    return newComment;
  }

  @override
  Future<Post> createPost({
    required String content,
    required List<String> tags,
    String? imageAsset,
    required PostAuthor author,
  }) async {
    await _simulateNetwork();
    final newPost = Post(
      id: 'pst_${DateTime.now().millisecondsSinceEpoch}',
      author: author,
      content: content,
      imageAsset: imageAsset,
      tags: tags,
      createdAt: DateTime.now(),
      likeCount: 0,
      repostCount: 0,
      commentCount: 0,
    );

    _posts = [newPost, ...?_posts];
    return newPost;
  }
}
