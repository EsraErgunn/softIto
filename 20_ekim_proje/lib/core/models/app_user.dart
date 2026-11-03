// =============================================================================
// app_user.dart - Kullanıcı ve girişim profili modelleri (freezed)
// freezed paketi; ==, hashCode, copyWith, toString ve JSON kodlarını OTOMATİK üretir.
// Üretilen kod app_user.freezed.dart ve app_user.g.dart dosyalarındadır.
// Model değişirse şu komutla yeniden üretilmelidir:
//   dart run build_runner build --delete-conflicting-outputs
// =============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

// "part": üretilen dosyalar bu dosyanın parçası sayılır (private _$ sınıflarına erişim için).
part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
// Girişimcinin şirket bilgileri (onboarding'de doldurulur).
abstract class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String startupName,
    required Sector sector,
    required StartupStage stage,
    // @Default: JSON'da veya constructor'da verilmezse kullanılacak değer.
    @Default(1) int teamSize,
    String? businessPlanFileName,
    @Default([]) List<NeedType> needs,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) => _$BusinessProfileFromJson(json);
}

@freezed
// Giriş yapan kullanıcı. role'e göre (girişimci/mentör/yatırımcı) farklı ekranlar görür.
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
    // Sadece girişimcilerde dolu olur; diğer rollerde null.
    BusinessProfile? businessProfile,
    String? rejectionReason,
  }) = _AppUser;

  // JSON -> nesne dönüşümü; asıl kod app_user.g.dart içinde üretilir.
  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}
