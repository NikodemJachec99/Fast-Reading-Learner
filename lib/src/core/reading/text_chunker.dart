/// Splits text into the units displayed during a reading exercise.
class TextChunker {
  const TextChunker();

  static final RegExp _whitespace = RegExp(r'\s+');

  /// Splits [text] into words, ignoring any surrounding or repeated
  /// whitespace (spaces, tabs, new lines).
  List<String> words(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const [];
    return trimmed.split(_whitespace);
  }

  /// Groups the words of [text] into chunks of [wordsPerChunk] words joined
  /// by a single space. The last chunk may be shorter.
  List<String> chunks(String text, {int wordsPerChunk = 1}) {
    if (wordsPerChunk < 1) {
      throw ArgumentError.value(
        wordsPerChunk,
        'wordsPerChunk',
        'must be at least 1',
      );
    }
    final allWords = words(text);
    return [
      for (var i = 0; i < allWords.length; i += wordsPerChunk)
        allWords
            .sublist(i, (i + wordsPerChunk).clamp(0, allWords.length))
            .join(' '),
    ];
  }
}
