import 'package:fast_reading_learner/src/core/storage/shared_preferences_provider.dart';
import 'package:fast_reading_learner/src/features/settings/app_settings.dart';
import 'package:fast_reading_learner/src/features/settings/settings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> containerWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    final preferences = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('settingsProvider', () {
    test('starts with the stored settings', () async {
      final container = await containerWith({
        'settings.readerTextSize': 'medium',
      });

      expect(
        container.read(settingsProvider).readerTextSize,
        ReaderTextSize.medium,
      );
    });

    test('updates state and storage when the text size changes', () async {
      final container = await containerWith({});

      await container
          .read(settingsProvider.notifier)
          .setReaderTextSize(ReaderTextSize.small);

      expect(
        container.read(settingsProvider).readerTextSize,
        ReaderTextSize.small,
      );
      final preferences = container.read(sharedPreferencesProvider);
      expect(preferences.getString('settings.readerTextSize'), 'small');
    });

    test('keeps reduced motion after an app restart', () async {
      final first = await containerWith({});
      await first
          .read(settingsProvider.notifier)
          .setReduceMotion(enabled: true);
      final preferences = first.read(sharedPreferencesProvider);

      final restarted = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );
      addTearDown(restarted.dispose);

      expect(restarted.read(settingsProvider).reduceMotion, isTrue);
    });
  });
}
