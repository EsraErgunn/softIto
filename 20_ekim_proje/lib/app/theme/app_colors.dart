import 'package:flutter/material.dart';

const kSeedColor = Color(0xFF3F51B5); // GEÇİCİ: renk kararı bekliyor

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.approved,
    required this.onApproved,
    required this.approvedContainer,
    required this.onApprovedContainer,
    required this.pending,
    required this.onPending,
    required this.pendingContainer,
    required this.onPendingContainer,
    required this.rejected,
    required this.onRejected,
    required this.rejectedContainer,
    required this.onRejectedContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.neutral,
    required this.onNeutral,
    required this.neutralContainer,
    required this.onNeutralContainer,
  });

  final Color approved;
  final Color onApproved;
  final Color approvedContainer;
  final Color onApprovedContainer;

  final Color pending;
  final Color onPending;
  final Color pendingContainer;
  final Color onPendingContainer;

  final Color rejected;
  final Color onRejected;
  final Color rejectedContainer;
  final Color onRejectedContainer;

  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  final Color neutral;
  final Color onNeutral;
  final Color neutralContainer;
  final Color onNeutralContainer;

  static const light = StatusColors(
    approved: Color(0xFF2E7D32),
    onApproved: Colors.white,
    approvedContainer: Color(0xFFE8F5E9),
    onApprovedContainer: Color(0xFF1B5E20),
    pending: Color(0xFFED6C02),
    onPending: Colors.white,
    pendingContainer: Color(0xFFFFF3E0),
    onPendingContainer: Color(0xFFE65100),
    rejected: Color(0xFFD32F2F),
    onRejected: Colors.white,
    rejectedContainer: Color(0xFFFFEBEE),
    onRejectedContainer: Color(0xFFC62828),
    info: Color(0xFF0288D1),
    onInfo: Colors.white,
    infoContainer: Color(0xFFE1F5FE),
    onInfoContainer: Color(0xFF01579B),
    neutral: Color(0xFF616161),
    onNeutral: Colors.white,
    neutralContainer: Color(0xFFF5F5F5),
    onNeutralContainer: Color(0xFF212121),
  );

  static const dark = StatusColors(
    approved: Color(0xFF81C784),
    onApproved: Color(0xFF1B5E20),
    approvedContainer: Color(0xFF1B3E20),
    onApprovedContainer: Color(0xFFA5D6A7),
    pending: Color(0xFFFFB74D),
    onPending: Color(0xFFE65100),
    pendingContainer: Color(0xFF4E2C00),
    onPendingContainer: Color(0xFFFFCC80),
    rejected: Color(0xFFE57373),
    onRejected: Color(0xFFC62828),
    rejectedContainer: Color(0xFF491818),
    onRejectedContainer: Color(0xFFEF9A9A),
    info: Color(0xFF4FC3F7),
    onInfo: Color(0xFF01579B),
    infoContainer: Color(0xFF003659),
    onInfoContainer: Color(0xFF81D4FA),
    neutral: Color(0xFFBDBDBD),
    onNeutral: Color(0xFF212121),
    neutralContainer: Color(0xFF303030),
    onNeutralContainer: Color(0xFFE0E0E0),
  );

  @override
  StatusColors copyWith({
    Color? approved,
    Color? onApproved,
    Color? approvedContainer,
    Color? onApprovedContainer,
    Color? pending,
    Color? onPending,
    Color? pendingContainer,
    Color? onPendingContainer,
    Color? rejected,
    Color? onRejected,
    Color? rejectedContainer,
    Color? onRejectedContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? neutral,
    Color? onNeutral,
    Color? neutralContainer,
    Color? onNeutralContainer,
  }) {
    return StatusColors(
      approved: approved ?? this.approved,
      onApproved: onApproved ?? this.onApproved,
      approvedContainer: approvedContainer ?? this.approvedContainer,
      onApprovedContainer: onApprovedContainer ?? this.onApprovedContainer,
      pending: pending ?? this.pending,
      onPending: onPending ?? this.onPending,
      pendingContainer: pendingContainer ?? this.pendingContainer,
      onPendingContainer: onPendingContainer ?? this.onPendingContainer,
      rejected: rejected ?? this.rejected,
      onRejected: onRejected ?? this.onRejected,
      rejectedContainer: rejectedContainer ?? this.rejectedContainer,
      onRejectedContainer: onRejectedContainer ?? this.onRejectedContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      neutral: neutral ?? this.neutral,
      onNeutral: onNeutral ?? this.onNeutral,
      neutralContainer: neutralContainer ?? this.neutralContainer,
      onNeutralContainer: onNeutralContainer ?? this.onNeutralContainer,
    );
  }

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(
      approved: Color.lerp(approved, other.approved, t)!,
      onApproved: Color.lerp(onApproved, other.onApproved, t)!,
      approvedContainer: Color.lerp(approvedContainer, other.approvedContainer, t)!,
      onApprovedContainer: Color.lerp(onApprovedContainer, other.onApprovedContainer, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
      onPending: Color.lerp(onPending, other.onPending, t)!,
      pendingContainer: Color.lerp(pendingContainer, other.pendingContainer, t)!,
      onPendingContainer: Color.lerp(onPendingContainer, other.onPendingContainer, t)!,
      rejected: Color.lerp(rejected, other.rejected, t)!,
      onRejected: Color.lerp(onRejected, other.onRejected, t)!,
      rejectedContainer: Color.lerp(rejectedContainer, other.rejectedContainer, t)!,
      onRejectedContainer: Color.lerp(onRejectedContainer, other.onRejectedContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      onNeutral: Color.lerp(onNeutral, other.onNeutral, t)!,
      neutralContainer: Color.lerp(neutralContainer, other.neutralContainer, t)!,
      onNeutralContainer: Color.lerp(onNeutralContainer, other.onNeutralContainer, t)!,
    );
  }
}
