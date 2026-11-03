// =============================================================================
// water_intake.dart - Tek bir su içme kaydı
// =============================================================================

import 'package:flutter/foundation.dart';

// @immutable: tüm alanların final olması gerektiğini belirtir; aksi halde analiz uyarı verir.
@immutable
class WaterIntake {
  final String id;
  final int amountMl;
  final DateTime timestamp;

  const WaterIntake({
    required this.id,
    required this.amountMl,
    required this.timestamp,
  });

  // Saati "09:05" biçiminde döner. padLeft(2, '0') tek haneli sayının başına 0 ekler.
  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
