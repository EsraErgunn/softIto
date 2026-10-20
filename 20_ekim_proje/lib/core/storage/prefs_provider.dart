import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'prefsProvider must be overridden in main() with an initialized SharedPreferences instance.',
  );
});
