import 'package:fast_reading_learner/src/features/progress/domain/session_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SessionRecord passing rule', () {
    test('passes for 2/3 and 3/3 correct', () {
      final session3Of3 = SessionRecord(
        id: '1',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'Test',
        timestamp: DateTime(2026, 10, 1),
        wpm: 220,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 60,
        wordCount: 220,
      );
      expect(session3Of3.isPassed, isTrue);

      final session2Of3 = SessionRecord(
        id: '2',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'Test',
        timestamp: DateTime(2026, 10, 1),
        wpm: 220,
        questionsCorrect: 2,
        totalQuestions: 3,
        readingDurationSeconds: 60,
        wordCount: 220,
      );
      expect(session2Of3.isPassed, isTrue);
    });

    test('fails for 1/3 correct', () {
      final session1Of3 = SessionRecord(
        id: '3',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'Test',
        timestamp: DateTime(2026, 10, 1),
        wpm: 240,
        questionsCorrect: 1,
        totalQuestions: 3,
        readingDurationSeconds: 45,
        wordCount: 180,
      );
      expect(session1Of3.isPassed, isFalse);
    });

    test('evaluates passing and failing correctly for 4 questions', () {
      // 3/4 = 75% >= 66.7% -> passed
      final session3Of4 = SessionRecord(
        id: '4',
        exerciseTitle: 'Test',
        textTitle: 'Test',
        timestamp: DateTime(2026, 10, 1),
        wpm: 200,
        questionsCorrect: 3,
        totalQuestions: 4,
        readingDurationSeconds: 60,
        wordCount: 200,
      );
      expect(session3Of4.isPassed, isTrue);

      // 2/4 = 50% < 66.7% -> failed
      final session2Of4 = SessionRecord(
        id: '5',
        exerciseTitle: 'Test',
        textTitle: 'Test',
        timestamp: DateTime(2026, 10, 1),
        wpm: 200,
        questionsCorrect: 2,
        totalQuestions: 4,
        readingDurationSeconds: 60,
        wordCount: 200,
      );
      expect(session2Of4.isPassed, isFalse);
    });

    test('evaluates passing and failing correctly for 5 questions', () {
      // 4/5 = 80% >= 66.7% -> passed
      final session4Of5 = SessionRecord(
        id: '6',
        exerciseTitle: 'Memory Map',
        textTitle: 'Test',
        timestamp: DateTime(2026, 10, 1),
        wpm: 205,
        questionsCorrect: 4,
        totalQuestions: 5,
        readingDurationSeconds: 60,
        wordCount: 205,
      );
      expect(session4Of5.isPassed, isTrue);

      // 3/5 = 60% < 66.7% -> failed
      final session3Of5 = SessionRecord(
        id: '7',
        exerciseTitle: 'Memory Map',
        textTitle: 'Test',
        timestamp: DateTime(2026, 10, 1),
        wpm: 205,
        questionsCorrect: 3,
        totalQuestions: 5,
        readingDurationSeconds: 60,
        wordCount: 205,
      );
      expect(session3Of5.isPassed, isFalse);
    });

    test('incomplete session is never passed', () {
      final incomplete = SessionRecord(
        id: '8',
        exerciseTitle: 'Test',
        textTitle: 'Test',
        timestamp: DateTime(2026, 10, 1),
        wpm: 200,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 60,
        wordCount: 200,
        isCompleted: false,
      );
      expect(incomplete.isPassed, isFalse);
    });
  });

  group('SessionRecord WPM calculation & serialization', () {
    test('calculates WPM using ReadingSpeed.fromSession correctly', () {
      // 180 words in 45 seconds = 240 WPM
      final session = SessionRecord.create(
        id: 's-wpm',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'Bees',
        timestamp: DateTime(2026, 10, 1),
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 45,
        wordCount: 180,
      );

      expect(session.wpm, 240);
    });

    test('supports JSON serialization roundtrip', () {
      final original = SessionRecord(
        id: 's-json',
        exerciseTitle: 'Read & Check',
        textTitle: 'Rivers',
        timestamp: DateTime(2026, 10, 5, 14, 30),
        wpm: 220,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 49,
        wordCount: 180,
      );

      final jsonStr = original.toJson();
      final revived = SessionRecord.fromJson(jsonStr);

      expect(revived.id, original.id);
      expect(revived.exerciseTitle, original.exerciseTitle);
      expect(revived.textTitle, original.textTitle);
      expect(revived.wpm, original.wpm);
      expect(revived.questionsCorrect, original.questionsCorrect);
      expect(revived.totalQuestions, original.totalQuestions);
      expect(revived.isPassed, isTrue);
    });
  });
}
