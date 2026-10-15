import 'package:fast_reading_learner/src/core/reading/text_chunker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const chunker = TextChunker();

  group('TextChunker.words', () {
    test('splits text on spaces', () {
      expect(chunker.words('The quick brown fox'), [
        'The',
        'quick',
        'brown',
        'fox',
      ]);
    });

    test('ignores repeated and surrounding whitespace', () {
      expect(chunker.words('  one \t two\n\nthree  '), ['one', 'two', 'three']);
    });

    test('keeps punctuation attached to words', () {
      expect(chunker.words('Hello, world!'), ['Hello,', 'world!']);
    });

    test('returns an empty list for blank text', () {
      expect(chunker.words(''), isEmpty);
      expect(chunker.words('   \n  '), isEmpty);
    });
  });

  group('TextChunker.chunks', () {
    const text = 'one two three four five';

    test('returns single words by default', () {
      expect(chunker.chunks(text), ['one', 'two', 'three', 'four', 'five']);
    });

    test('groups words into chunks of the given size', () {
      expect(chunker.chunks(text, wordsPerChunk: 2), [
        'one two',
        'three four',
        'five',
      ]);
    });

    test('returns one chunk when the size exceeds the word count', () {
      expect(chunker.chunks(text, wordsPerChunk: 10), [text]);
    });

    test('returns an empty list for blank text', () {
      expect(chunker.chunks('  ', wordsPerChunk: 3), isEmpty);
    });

    test('rejects chunk sizes below 1', () {
      expect(() => chunker.chunks(text, wordsPerChunk: 0), throwsArgumentError);
    });
  });
}
