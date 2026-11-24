import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The app's [SharedPreferences] instance.
///
/// It is loaded once in `main()` and passed in with an override, so
/// repositories can read and write synchronously. Tests override it with an
/// instance created after `SharedPreferences.setMockInitialValues`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main() or in tests.',
  ),
);
