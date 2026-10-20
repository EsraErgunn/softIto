import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'consultant.freezed.dart';
part 'consultant.g.dart';

@freezed
abstract class Consultant with _$Consultant {
  const factory Consultant({
    required String id,
    required String name,
    required String title,
    required ConsultantField field,
    required String bio,
    String? avatarAsset,
    @Default([]) List<String> availableHours,
  }) = _Consultant;

  factory Consultant.fromJson(Map<String, dynamic> json) => _$ConsultantFromJson(json);
}

@freezed
abstract class ConsultationSession with _$ConsultationSession {
  const factory ConsultationSession({
    required String id,
    required String userId,
    required String consultantId,
    required ConsultantField field,
    required DateTime date,
    required String timeSlot,
    @Default('confirmed') String status,
  }) = _ConsultationSession;

  factory ConsultationSession.fromJson(Map<String, dynamic> json) =>
      _$ConsultationSessionFromJson(json);
}
