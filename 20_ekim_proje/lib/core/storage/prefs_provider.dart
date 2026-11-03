// =============================================================================
// prefs_provider.dart - SharedPreferences erişim noktası
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefsProvider = Provider<SharedPreferences>((ref) {
  // Kasıtlı olarak hata fırlatır: gerçek değer main.dart'ta overrideWithValue ile verilir.
  // Override unutulursa hata hemen fark edilir.
  throw UnimplementedError(
    'prefsProvider must be overridden in main() with an initialized SharedPreferences instance.',
  );
});
