import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/shared_preferences_provider.dart';
import 'app_settings.dart';

/// Reads and writes [AppSettings] in [SharedPreferences].
///
/// This is the only place that knows the storage keys. Use the same shape
/// for other data: one repository per feature, behind a provider.
class SettingsRepository {
  const SettingsRepository(this._preferences);

  final SharedPreferences _preferences;

  static const String _readerTextSizeKey = 'settings.readerTextSize';
  static const String _reduceMotionKey = 'settings.reduceMotion';

  /// Loads the saved settings, falling back to defaults for missing or
  /// unknown values.
  AppSettings load() {
    const defaults = AppSettings();
    final sizeName = _preferences.getString(_readerTextSizeKey);
    final size = ReaderTextSize.values
        .where((value) => value.name == sizeName)
        .firstOrNull;
    return AppSettings(
      readerTextSize: size ?? defaults.readerTextSize,
      reduceMotion:
          _preferences.getBool(_reduceMotionKey) ?? defaults.reduceMotion,
    );
  }

  /// Saves all [settings].
  Future<void> save(AppSettings settings) async {
    await _preferences.setString(
      _readerTextSizeKey,
      settings.readerTextSize.name,
    );
    await _preferences.setBool(_reduceMotionKey, settings.reduceMotion);
  }
}

/// Provides the [SettingsRepository] backed by the app's preferences.
final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);
