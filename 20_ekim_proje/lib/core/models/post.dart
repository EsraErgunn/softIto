import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class PostAuthor with _$PostAuthor {
  const factory PostAuthor({
    required String id,
    required String name,
    required UserRole role,
    @Default(false) bool isVerified,
    String? avatarAsset,
  }) = _PostAuthor;

  factory PostAuthor.fromJson(Map<String, dynamic> json) => _$PostAuthorFromJson(json);
}

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required PostAuthor author,
    required String content,
    String? imageAsset,
    @Default([]) List<String> tags,
    required DateTime createdAt,
    @Default(0) int likeCount,
    @Default(0) int repostCount,
    @Default(0) int commentCount,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String postId,
    required PostAuthor author,
    required String content,
    required DateTime createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
