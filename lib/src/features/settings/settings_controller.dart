import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_settings.dart';
import 'settings_repository.dart';

/// Holds the current [AppSettings] and saves every change.
///
/// Widgets read it with `ref.watch(settingsProvider)` and change it with
/// `ref.read(settingsProvider.notifier).setReaderTextSize(...)`.
class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(settingsRepositoryProvider).load();

  /// Changes the reader text size and saves it.
  Future<void> setReaderTextSize(ReaderTextSize size) =>
      _update(state.copyWith(readerTextSize: size));

  /// Turns reduced motion on or off and saves it.
  Future<void> setReduceMotion({required bool enabled}) =>
      _update(state.copyWith(reduceMotion: enabled));

  Future<void> _update(AppSettings settings) async {
    state = settings;
    await ref.read(settingsRepositoryProvider).save(settings);
  }
}

/// The current settings, kept in sync with storage.
final settingsProvider = NotifierProvider<SettingsController, AppSettings>(
  SettingsController.new,
);
