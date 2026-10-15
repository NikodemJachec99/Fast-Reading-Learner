import 'package:fast_reading_learner/src/core/reading/reading_speed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReadingSpeed', () {
    test('stores words per minute within the allowed range', () {
      expect(ReadingSpeed(300).wordsPerMinute, 300);
    });

    test('accepts the range boundaries', () {
      expect(
        ReadingSpeed(ReadingSpeed.minWordsPerMinute).wordsPerMinute,
        ReadingSpeed.minWordsPerMinute,
      );
      expect(
        ReadingSpeed(ReadingSpeed.maxWordsPerMinute).wordsPerMinute,
        ReadingSpeed.maxWordsPerMinute,
      );
    });

    test('throws for values outside the allowed range', () {
      expect(() => ReadingSpeed(49), throwsRangeError);
      expect(() => ReadingSpeed(1501), throwsRangeError);
    });

    test('clamped() keeps values within the allowed range', () {
      expect(ReadingSpeed.clamped(10).wordsPerMinute, 50);
      expect(ReadingSpeed.clamped(5000).wordsPerMinute, 1500);
      expect(ReadingSpeed.clamped(400).wordsPerMinute, 400);
    });

    group('durationPerWord', () {
      test('is 200 ms at 300 WPM', () {
        expect(
          ReadingSpeed(300).durationPerWord,
          const Duration(milliseconds: 200),
        );
      });

      test('is 1 second at 60 WPM', () {
        expect(ReadingSpeed(60).durationPerWord, const Duration(seconds: 1));
      });

      test('gets shorter as speed increases', () {
        expect(
          ReadingSpeed(600).durationPerWord,
          lessThan(ReadingSpeed(300).durationPerWord),
        );
      });
    });

    group('fromSession', () {
      test('calculates WPM from words read and elapsed time', () {
        final speed = ReadingSpeed.fromSession(
          wordsRead: 500,
          elapsed: const Duration(minutes: 2),
        );
        expect(speed.wordsPerMinute, 250);
      });

      test('rounds to the nearest whole WPM', () {
        final speed = ReadingSpeed.fromSession(
          wordsRead: 100,
          elapsed: const Duration(seconds: 23),
        );
        expect(speed.wordsPerMinute, 261);
      });

      test('clamps unrealistic results', () {
        final speed = ReadingSpeed.fromSession(
          wordsRead: 1000,
          elapsed: const Duration(seconds: 1),
        );
        expect(speed.wordsPerMinute, ReadingSpeed.maxWordsPerMinute);
      });

      test('rejects negative word counts', () {
        expect(
          () => ReadingSpeed.fromSession(
            wordsRead: -1,
            elapsed: const Duration(minutes: 1),
          ),
          throwsArgumentError,
        );
      });

      test('rejects zero or negative elapsed time', () {
        expect(
          () => ReadingSpeed.fromSession(wordsRead: 10, elapsed: Duration.zero),
          throwsArgumentError,
        );
      });
    });

    test('supports value equality', () {
      expect(ReadingSpeed(300), ReadingSpeed(300));
      expect(ReadingSpeed(300), isNot(ReadingSpeed(301)));
      expect(ReadingSpeed(300).hashCode, ReadingSpeed(300).hashCode);
    });
  });
}
