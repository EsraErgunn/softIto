import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info.freezed.dart';
part 'contact_info.g.dart';

@freezed
abstract class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    required String email,
    String? phone,
    String? linkedinUrl,
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, dynamic> json) => _$ContactInfoFromJson(json);
}
