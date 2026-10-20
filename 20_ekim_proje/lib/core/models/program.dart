import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'program.freezed.dart';
part 'program.g.dart';

@freezed
abstract class Program with _$Program {
  const factory Program({
    required String id,
    required String title,
    required String provider,
    required ProgramType type,
    required ProgramScope scope,
    String? country,
    required int amountMax,
    required DateTime deadline,
    required String summary,
    @Default([]) List<String> eligibility,
    @Default([]) List<StartupStage> targetStages,
    @Default([]) List<Sector> sectors,
    @Default(false) bool requiresVerification,
    @Default([]) List<String> tags,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);
}
