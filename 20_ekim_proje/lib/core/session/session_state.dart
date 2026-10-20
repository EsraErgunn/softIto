import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/app_user.dart';

part 'session_state.freezed.dart';
part 'session_state.g.dart';

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState({
    AppUser? user,
    @Default(false) bool onboardingDone,
  }) = _SessionState;

  factory SessionState.fromJson(Map<String, dynamic> json) => _$SessionStateFromJson(json);
}
