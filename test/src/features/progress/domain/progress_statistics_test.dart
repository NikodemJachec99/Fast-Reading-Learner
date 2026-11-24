import 'package:fast_reading_learner/src/features/progress/domain/progress_period.dart';
import 'package:fast_reading_learner/src/features/progress/domain/progress_statistics.dart';
import 'package:fast_reading_learner/src/features/progress/domain/session_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final refDate = DateTime(2026, 10, 15, 12, 0);

  group('ProgressStatistics core calculations', () {
    test('handles empty sessions gracefully without errors', () {
      final stats = ProgressStatistics.compute(
        sessions: [],
        period: ProgressPeriod.sevenDays,
        referenceDate: refDate,
      );

      expect(stats.completedSessionsCount, 0);
      expect(stats.averagePassedWpm, isNull);
      expect(stats.totalQuestionsCorrect, 0);
      expect(stats.totalQuestionsAsked, 0);
      expect(stats.trendWpm, isNull);
      expect(stats.filteredSessions, isEmpty);
      expect(stats.chartPoints.length, 7);
      expect(stats.chartPoints.every((p) => p.wpm == null), isTrue);
    });

    test('average WPM excludes failed sessions', () {
      final sessions = [
        SessionRecord(
          id: '1',
          exerciseTitle: 'A',
          textTitle: 'T1',
          timestamp: refDate.subtract(const Duration(days: 1)),
          wpm: 200,
          questionsCorrect: 3,
          totalQuestions: 3, // Passed
          readingDurationSeconds: 60,
          wordCount: 200,
        ),
        SessionRecord(
          id: '2',
          exerciseTitle: 'B',
          textTitle: 'T2',
          timestamp: refDate.subtract(const Duration(days: 2)),
          wpm: 250,
          questionsCorrect: 3,
          totalQuestions: 3, // Passed
          readingDurationSeconds: 60,
          wordCount: 250,
        ),
        SessionRecord(
          id: '3',
          exerciseTitle: 'C',
          textTitle: 'T3',
          timestamp: refDate.subtract(const Duration(days: 3)),
          wpm: 500, // Very fast, but failed comprehension!
          questionsCorrect: 1,
          totalQuestions: 3, // Failed (< 2/3)
          readingDurationSeconds: 30,
          wordCount: 250,
        ),
      ];

      final stats = ProgressStatistics.compute(
        sessions: sessions,
        period: ProgressPeriod.sevenDays,
        referenceDate: refDate,
      );

      // Average of passed only: (200 + 250) / 2 = 225. 500 wpm is excluded!
      expect(stats.averagePassedWpm, 225);
    });

    test('comprehension includes failed sessions', () {
      final sessions = [
        SessionRecord(
          id: '1',
          exerciseTitle: 'A',
          textTitle: 'T1',
          timestamp: refDate.subtract(const Duration(days: 1)),
          wpm: 200,
          questionsCorrect: 3,
          totalQuestions: 3, // Passed
          readingDurationSeconds: 60,
          wordCount: 200,
        ),
        SessionRecord(
          id: '2',
          exerciseTitle: 'B',
          textTitle: 'T2',
          timestamp: refDate.subtract(const Duration(days: 2)),
          wpm: 300,
          questionsCorrect: 1,
          totalQuestions: 3, // Failed
          readingDurationSeconds: 40,
          wordCount: 200,
        ),
      ];

      final stats = ProgressStatistics.compute(
        sessions: sessions,
        period: ProgressPeriod.sevenDays,
        referenceDate: refDate,
      );

      // Total correct = 3 + 1 = 4. Total asked = 3 + 3 = 6.
      expect(stats.totalQuestionsCorrect, 4);
      expect(stats.totalQuestionsAsked, 6);
    });

    test('completed session count excludes incomplete sessions', () {
      final sessions = [
        SessionRecord(
          id: '1',
          exerciseTitle: 'A',
          textTitle: 'T1',
          timestamp: refDate.subtract(const Duration(days: 1)),
          wpm: 200,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 200,
          isCompleted: true,
        ),
        SessionRecord(
          id: '2',
          exerciseTitle: 'B',
          textTitle: 'T2',
          timestamp: refDate.subtract(const Duration(days: 2)),
          wpm: 200,
          questionsCorrect: 0,
          totalQuestions: 3,
          readingDurationSeconds: 20,
          wordCount: 60,
          isCompleted: false, // Incomplete!
        ),
      ];

      final stats = ProgressStatistics.compute(
        sessions: sessions,
        period: ProgressPeriod.sevenDays,
        referenceDate: refDate,
      );

      expect(stats.completedSessionsCount, 1);
      expect(stats.filteredSessions.length, 1);
    });

    test('filters sessions by 7 days and 30 days', () {
      final sessions = [
        SessionRecord(
          id: '1',
          exerciseTitle: 'Recent',
          textTitle: 'T1',
          timestamp: refDate.subtract(const Duration(days: 2)),
          wpm: 200,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 200,
        ),
        SessionRecord(
          id: '2',
          exerciseTitle: 'Mid',
          textTitle: 'T2',
          timestamp: refDate.subtract(const Duration(days: 12)),
          wpm: 220,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 220,
        ),
        SessionRecord(
          id: '3',
          exerciseTitle: 'Old',
          textTitle: 'T3',
          timestamp: refDate.subtract(const Duration(days: 45)),
          wpm: 180,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 180,
        ),
      ];

      final stats7 = ProgressStatistics.compute(
        sessions: sessions,
        period: ProgressPeriod.sevenDays,
        referenceDate: refDate,
      );
      expect(stats7.completedSessionsCount, 1);
      expect(stats7.filteredSessions.first.id, '1');

      final stats30 = ProgressStatistics.compute(
        sessions: sessions,
        period: ProgressPeriod.thirtyDays,
        referenceDate: refDate,
      );
      expect(stats30.completedSessionsCount, 2);
      expect(
        stats30.filteredSessions.map((s) => s.id),
        containsAll(['1', '2']),
      );
      expect(stats30.filteredSessions.map((s) => s.id), isNot(contains('3')));
    });

    test('sorts history newest first', () {
      final sessions = [
        SessionRecord(
          id: 'oldest',
          exerciseTitle: 'A',
          textTitle: 'T1',
          timestamp: refDate.subtract(const Duration(days: 3)),
          wpm: 200,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 200,
        ),
        SessionRecord(
          id: 'newest',
          exerciseTitle: 'B',
          textTitle: 'T2',
          timestamp: refDate.subtract(const Duration(hours: 2)),
          wpm: 230,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 230,
        ),
        SessionRecord(
          id: 'middle',
          exerciseTitle: 'C',
          textTitle: 'T3',
          timestamp: refDate.subtract(const Duration(days: 1)),
          wpm: 210,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 210,
        ),
      ];

      final stats = ProgressStatistics.compute(
        sessions: sessions,
        period: ProgressPeriod.sevenDays,
        referenceDate: refDate,
      );

      expect(stats.filteredSessions.map((s) => s.id).toList(), [
        'newest',
        'middle',
        'oldest',
      ]);
    });

    test('calculates trend comparing current period with preceding equivalent period', () {
      final sessions = [
        // Current 7-day period passed sessions (avg = 230)
        SessionRecord(
          id: 'cur-1',
          exerciseTitle: 'A',
          textTitle: 'T1',
          timestamp: refDate.subtract(const Duration(days: 1)),
          wpm: 230,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 230,
        ),
        // Preceding 7-day period passed sessions (avg = 200)
        SessionRecord(
          id: 'prev-1',
          exerciseTitle: 'B',
          textTitle: 'T2',
          timestamp: refDate.subtract(const Duration(days: 8)),
          wpm: 200,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 200,
        ),
      ];

      final stats = ProgressStatistics.compute(
        sessions: sessions,
        period: ProgressPeriod.sevenDays,
        referenceDate: refDate,
      );

      // 230 - 200 = +30
      expect(stats.trendWpm, 30);
    });

    test('returns null trend when insufficient preceding data exists', () {
      final sessions = [
        SessionRecord(
          id: 'cur-1',
          exerciseTitle: 'A',
          textTitle: 'T1',
          timestamp: refDate.subtract(const Duration(days: 1)),
          wpm: 230,
          questionsCorrect: 3,
          totalQuestions: 3,
          readingDurationSeconds: 60,
          wordCount: 230,
        ),
      ];

      final stats = ProgressStatistics.compute(
        sessions: sessions,
        period: ProgressPeriod.sevenDays,
        referenceDate: refDate,
      );

      expect(stats.trendWpm, isNull);
    });

    test(
      'chart points represent days without passed sessions as null, not zero',
      () {
        final sessions = [
          SessionRecord(
            id: 'day-1',
            exerciseTitle: 'A',
            textTitle: 'T1',
            timestamp: refDate.subtract(const Duration(days: 1)),
            wpm: 210,
            questionsCorrect: 3,
            totalQuestions: 3,
            readingDurationSeconds: 60,
            wordCount: 210,
          ),
        ];

        final stats = ProgressStatistics.compute(
          sessions: sessions,
          period: ProgressPeriod.sevenDays,
          referenceDate: refDate,
        );

        final emptyDays = stats.chartPoints
            .where((p) => p.date != stats.chartPoints[5].date)
            .toList();
        for (final emptyDay in emptyDays) {
          expect(emptyDay.wpm, isNull);
        }
      },
    );
  });
}
