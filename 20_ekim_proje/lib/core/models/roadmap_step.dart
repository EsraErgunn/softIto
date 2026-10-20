import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'roadmap_step.freezed.dart';
part 'roadmap_step.g.dart';

@freezed
abstract class RoadmapStep with _$RoadmapStep {
  const factory RoadmapStep({
    required String id,
    required int order,
    required RoadmapCategory category,
    required String title,
    required String description,
    @Default(false) bool isCompleted,
  }) = _RoadmapStep;

  factory RoadmapStep.fromJson(Map<String, dynamic> json) => _$RoadmapStepFromJson(json);
}
