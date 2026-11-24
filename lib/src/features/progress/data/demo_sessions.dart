import '../domain/session_record.dart';

/// Provides realistic sample sessions representing the presentation mockup (Slide 12).
///
/// Kept strictly separate from the user's persistent real history.
abstract final class DemoSessions {
  static List<SessionRecord> createSampleSessions({DateTime? referenceDate}) {
    final now = referenceDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 8, 41);

    return [
      SessionRecord(
        id: 'demo-1',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'The New Library',
        timestamp: today,
        wpm: 236,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 46,
        wordCount: 180,
      ),
      SessionRecord(
        id: 'demo-2',
        exerciseTitle: 'Read & Check',
        textTitle: 'Rivers',
        timestamp: today.subtract(const Duration(days: 1, hours: 2)),
        wpm: 220,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 49,
        wordCount: 180,
      ),
      SessionRecord(
        id: 'demo-3',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'Bees',
        timestamp: today.subtract(const Duration(days: 3, hours: 1)),
        wpm: 240,
        questionsCorrect: 1,
        totalQuestions: 3, // Failed (< 2/3) -> excluded from avg speed
        readingDurationSeconds: 45,
        wordCount: 180,
      ),
      SessionRecord(
        id: 'demo-4',
        exerciseTitle: 'Memory Map',
        textTitle: 'The heart',
        timestamp: today.subtract(const Duration(days: 4, hours: 3)),
        wpm: 205,
        questionsCorrect: 4,
        totalQuestions: 5,
        readingDurationSeconds: 58,
        wordCount: 200,
      ),
      SessionRecord(
        id: 'demo-5',
        exerciseTitle: 'Read & Check',
        textTitle: 'Space flight',
        timestamp: today.subtract(const Duration(days: 5, hours: 4)),
        wpm: 195,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 55,
        wordCount: 180,
      ),
      SessionRecord(
        id: 'demo-6',
        exerciseTitle: 'Info Hunter',
        textTitle: 'Deep Sea Exploration',
        timestamp: today.subtract(const Duration(days: 6, hours: 2)),
        wpm: 201,
        questionsCorrect: 3,
        totalQuestions:
            3, // Total correct: 3 + 3 + 1 + 4 + 3 + 3 = 17 / 20 (or 17/18)
        readingDurationSeconds: 54,
        wordCount: 180,
      ),
      // Preceding period session to produce +38 wpm trend
      SessionRecord(
        id: 'demo-prev-1',
        exerciseTitle: 'Read & Check',
        textTitle: 'Early Printing',
        timestamp: today.subtract(const Duration(days: 9)),
        wpm: 173,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 62,
        wordCount: 180,
      ),
    ];
  }
}
