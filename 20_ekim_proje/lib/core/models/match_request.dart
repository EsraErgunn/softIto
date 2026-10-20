import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'match_request.freezed.dart';
part 'match_request.g.dart';

@freezed
abstract class MatchRequest with _$MatchRequest {
  const factory MatchRequest({
    required String id,
    required String fromUserId,
    required String toUserId,
    required String targetKind, // 'mentor' veya 'investor'
    String? message,
    @Default(MatchStatus.pending) MatchStatus status,
    required DateTime createdAt,
  }) = _MatchRequest;

  factory MatchRequest.fromJson(Map<String, dynamic> json) => _$MatchRequestFromJson(json);
}
