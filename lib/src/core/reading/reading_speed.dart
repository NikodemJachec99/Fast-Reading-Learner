/// A reading speed expressed in words per minute (WPM).
class ReadingSpeed {
  /// Creates a reading speed. [wordsPerMinute] must be within
  /// [minWordsPerMinute] and [maxWordsPerMinute].
  ReadingSpeed(this.wordsPerMinute) {
    if (wordsPerMinute < minWordsPerMinute ||
        wordsPerMinute > maxWordsPerMinute) {
      throw RangeError.range(
        wordsPerMinute,
        minWordsPerMinute,
        maxWordsPerMinute,
        'wordsPerMinute',
      );
    }
  }

  /// Creates a reading speed, clamping [wordsPerMinute] to the allowed range.
  factory ReadingSpeed.clamped(int wordsPerMinute) {
    return ReadingSpeed(
      wordsPerMinute.clamp(minWordsPerMinute, maxWordsPerMinute),
    );
  }

  /// Measures the speed of a finished reading session.
  ///
  /// The result is clamped to the allowed range.
  factory ReadingSpeed.fromSession({
    required int wordsRead,
    required Duration elapsed,
  }) {
    if (wordsRead < 0) {
      throw ArgumentError.value(wordsRead, 'wordsRead', 'must not be negative');
    }
    if (elapsed <= Duration.zero) {
      throw ArgumentError.value(elapsed, 'elapsed', 'must be positive');
    }
    final minutes = elapsed.inMicroseconds / Duration.microsecondsPerMinute;
    return ReadingSpeed.clamped((wordsRead / minutes).round());
  }

  static const int minWordsPerMinute = 50;
  static const int maxWordsPerMinute = 1500;

  final int wordsPerMinute;

  /// How long a single word should stay on screen at this speed.
  Duration get durationPerWord => Duration(
    microseconds: (Duration.microsecondsPerMinute / wordsPerMinute).round(),
  );

  @override
  bool operator ==(Object other) =>
      other is ReadingSpeed && other.wordsPerMinute == wordsPerMinute;

  @override
  int get hashCode => wordsPerMinute.hashCode;

  @override
  String toString() => 'ReadingSpeed($wordsPerMinute WPM)';
}
