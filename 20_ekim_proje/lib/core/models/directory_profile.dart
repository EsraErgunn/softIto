import 'package:freezed_annotation/freezed_annotation.dart';
import 'contact_info.dart';
import 'enums.dart';

part 'directory_profile.freezed.dart';
part 'directory_profile.g.dart';

@Freezed(unionKey: 'kind')
abstract class DirectoryProfile with _$DirectoryProfile {
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
