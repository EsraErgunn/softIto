import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'support_application.freezed.dart';
part 'support_application.g.dart';

@freezed
abstract class SupportApplication with _$SupportApplication {
  const factory SupportApplication({
    required String id,
    required String userId,
    required int amount,
    required String purpose,
    @Default(SupportStatus.pending) SupportStatus status,
    required DateTime appliedAt,
  }) = _SupportApplication;

  factory SupportApplication.fromJson(Map<String, dynamic> json) =>
      _$SupportApplicationFromJson(json);
}
