import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../storage/prefs_provider.dart';
import 'session_state.dart';

const _kSessionKey = 'app_session_state';

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() {
    final prefs = ref.watch(prefsProvider);
    final raw = prefs.getString(_kSessionKey);
    if (raw == null || raw.isEmpty) {
      return const SessionState();
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return SessionState.fromJson(json);
    } catch (_) {
      return const SessionState();
    }
  }

  Future<void> _persist(SessionState newState) async {
    state = newState;
    final prefs = ref.read(prefsProvider);
    await prefs.setString(_kSessionKey, jsonEncode(newState.toJson()));
  }

  Future<void> login(AppUser user) async {
    final done = user.role != UserRole.entrepreneur || user.businessProfile != null;
    await _persist(SessionState(user: user, onboardingDone: done));
  }

  Future<void> logout() async {
    await _persist(const SessionState());
  }

  Future<void> setOnboardingDone(bool done) async {
    await _persist(state.copyWith(onboardingDone: done));
  }

  Future<void> updateUser(AppUser updatedUser) async {
    await _persist(state.copyWith(user: updatedUser));
  }

  Future<void> setVerificationStatus(VerificationStatus status, {String? rejectionReason}) async {
    final currentUser = state.user;
    if (currentUser == null) return;
    final updated = currentUser.copyWith(
      verificationStatus: status,
      rejectionReason: rejectionReason,
    );
    await updateUser(updated);
  }

  Future<void> submitVerification() async {
    await setVerificationStatus(VerificationStatus.pending);
  }

  Future<void> setHasBusinessPlan(bool hasPlan) async {
    final currentUser = state.user;
    if (currentUser == null) return;
    final updated = currentUser.copyWith(hasBusinessPlan: hasPlan);
    await updateUser(updated);
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);

final isApprovedProvider = Provider<bool>((ref) {
  final user = ref.watch(sessionProvider).user;
  return user?.verificationStatus == VerificationStatus.approved;
});

final currentRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(sessionProvider).user?.role;
});

final profileCompletionProvider = Provider<int>((ref) {
  final user = ref.watch(sessionProvider).user;
  if (user == null) return 0;

  int totalPoints = 0;
  int earnedPoints = 0;

  // Temel bilgiler: Ad, Email, Şehir, Bio
  totalPoints += 4;
  if (user.name.isNotEmpty) earnedPoints++;
  if (user.email.isNotEmpty) earnedPoints++;
  if (user.city.isNotEmpty) earnedPoints++;
  if (user.bio != null && user.bio!.isNotEmpty) earnedPoints++;

  // Girişimci ise girişim profili
  if (user.role == UserRole.entrepreneur) {
    totalPoints += 4;
    final bp = user.businessProfile;
    if (bp != null) {
      if (bp.startupName.isNotEmpty) earnedPoints++;
      earnedPoints++; // sector
      earnedPoints++; // stage
      if (bp.needs.isNotEmpty) earnedPoints++;
    }
  }

  return ((earnedPoints / totalPoints) * 100).round().clamp(0, 100);
});
