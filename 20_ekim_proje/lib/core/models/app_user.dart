import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String startupName,
    required Sector sector,
    required StartupStage stage,
    @Default(1) int teamSize,
    String? businessPlanFileName,
    @Default([]) List<NeedType> needs,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) => _$BusinessProfileFromJson(json);
}

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String name,
    required UserRole role,
    required String email,
    required String city,
    String? bio,
    String? avatarAsset,
    @Default(VerificationStatus.notStarted) VerificationStatus verificationStatus,
    @Default(false) bool hasBusinessPlan,
    BusinessProfile? businessProfile,
    String? rejectionReason,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
