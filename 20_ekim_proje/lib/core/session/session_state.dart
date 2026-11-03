// =============================================================================
// session_state.dart - Oturum durumu modeli (freezed)
// =============================================================================

import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/app_user.dart';

part 'session_state.freezed.dart';
part 'session_state.g.dart';

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState({
    // null -> giriş yapılmamış.
    AppUser? user,
    // Girişimcinin ilk kurulum adımlarını tamamlayıp tamamlamadığı.
    @Default(false) bool onboardingDone,
  }) = _SessionState;

  factory SessionState.fromJson(Map<String, dynamic> json) => _$SessionStateFromJson(json);
}
