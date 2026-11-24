import 'package:fast_reading_learner/src/features/settings/app_settings.dart';
import 'package:fast_reading_learner/src/features/settings/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<SettingsRepository> repositoryWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SettingsRepository(await SharedPreferences.getInstance());
  }

  group('SettingsRepository', () {
    test('returns defaults when nothing is stored', () async {
      final repository = await repositoryWith({});

      expect(repository.load(), const AppSettings());
    });

    test('loads what was saved', () async {
      final repository = await repositoryWith({});
      const settings = AppSettings(
        readerTextSize: ReaderTextSize.small,
        reduceMotion: true,
      );

      await repository.save(settings);

      expect(repository.load(), settings);
    });

    test('falls back to the default text size for unknown values', () async {
      final repository = await repositoryWith({
        'settings.readerTextSize': 'huge',
        'settings.reduceMotion': true,
      });

      expect(repository.load(), const AppSettings(reduceMotion: true));
    });
  });
}
