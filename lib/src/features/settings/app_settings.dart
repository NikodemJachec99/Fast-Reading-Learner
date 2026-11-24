/// Size of the text on reading screens.
enum ReaderTextSize {
  small(17),
  medium(19),
  large(21);

  const ReaderTextSize(this.fontSize);

  /// Font size in logical pixels.
  final double fontSize;
}

/// User preferences stored on the device.
class AppSettings {
  const AppSettings({
    this.readerTextSize = ReaderTextSize.large,
    this.reduceMotion = false,
  });

  final ReaderTextSize readerTextSize;
  final bool reduceMotion;

  /// Returns a copy with the given fields replaced.
  AppSettings copyWith({ReaderTextSize? readerTextSize, bool? reduceMotion}) {
    return AppSettings(
      readerTextSize: readerTextSize ?? this.readerTextSize,
      reduceMotion: reduceMotion ?? this.reduceMotion,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.readerTextSize == readerTextSize &&
      other.reduceMotion == reduceMotion;

  @override
  int get hashCode => Object.hash(readerTextSize, reduceMotion);

  @override
  String toString() =>
      'AppSettings(readerTextSize: $readerTextSize, reduceMotion: $reduceMotion)';
}
