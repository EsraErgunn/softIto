// =============================================================================
// directory_profile.dart - Rehber profili: Mentor veya Investor (freezed "union" tipi)
// Union (birleşik) tip: tek bir DirectoryProfile tipi altında iki farklı yapı.
// Ortak alanlar (id, name, bio, city...) her ikisinde de vardır; diğerleri türe özeldir.
// Kullanırken "switch (profile) { Mentor() => ..., Investor() => ... }" ile ayrılır.
// =============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';
import 'contact_info.dart';
import 'enums.dart';

part 'directory_profile.freezed.dart';
part 'directory_profile.g.dart';

// JSON'daki "kind" alanı hangi türün oluşturulacağını belirler ('mentor' / 'investor').
@Freezed(unionKey: 'kind')
abstract class DirectoryProfile with _$DirectoryProfile {
  // Mentör: unvan, uzmanlık sektörleri, konular ve deneyim yılı.
  const factory DirectoryProfile.mentor({
    @Default('mentor') String kind,
    required String id,
    required String name,
    required String bio,
    required String city,
    @Default(false) bool isVerified,
    required ContactInfo contact,
    required String title,
    @Default([]) List<Sector> expertise,
    @Default([]) List<NeedType> topics,
    @Default(0) int yearsOfExperience,
    String? avatarAsset,
  }) = Mentor;

  // Yatırımcı: firma, yatırımcı tipi, yatırım aralığı (ticket), sektör ve aşamalar.
  const factory DirectoryProfile.investor({
    @Default('investor') String kind,
    required String id,
    required String name,
    required String bio,
    required String city,
    @Default(false) bool isVerified,
    required ContactInfo contact,
    required String firm,
    required InvestorType investorType,
    // Bir girişime yapılan minimum / maksimum yatırım tutarı.
    required int ticketMin,
    required int ticketMax,
    @Default([]) List<Sector> sectors,
    @Default([]) List<StartupStage> stages,
    String? avatarAsset,
    @Default([]) List<String> portfolio,
    String? thesis,
  }) = Investor;

  factory DirectoryProfile.fromJson(Map<String, dynamic> json) => _$DirectoryProfileFromJson(json);
}
