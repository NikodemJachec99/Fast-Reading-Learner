import 'package:fast_reading_learner/src/features/progress/data/shared_preferences_session_repository.dart';
import 'package:fast_reading_learner/src/features/progress/domain/session_record.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesSessionRepository', () {
    late SharedPreferences prefs;
    late SharedPreferencesSessionRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = SharedPreferencesSessionRepository(preferences: prefs);
    });

    test('returns empty list when no data is saved', () async {
      final sessions = await repo.getSessions();
      expect(sessions, isEmpty);
    });

    test('saves and retrieves sessions correctly', () async {
      final session = SessionRecord(
        id: 'test-1',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'Sample',
        timestamp: DateTime(2026, 10, 1, 9, 30),
        wpm: 215,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 50,
        wordCount: 180,
      );

      await repo.saveSession(session);

      final retrieved = await repo.getSessions();
      expect(retrieved.length, 1);
      expect(retrieved.first.id, 'test-1');
      expect(retrieved.first.wpm, 215);
      expect(retrieved.first.isPassed, isTrue);
    });

    test('deletes a session by id', () async {
      final session1 = SessionRecord(
        id: 'test-1',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'Sample 1',
        timestamp: DateTime(2026, 10, 1),
        wpm: 215,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 50,
        wordCount: 180,
      );
      final session2 = SessionRecord(
        id: 'test-2',
        exerciseTitle: 'Read & Check',
        textTitle: 'Sample 2',
        timestamp: DateTime(2026, 10, 2),
        wpm: 230,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 45,
        wordCount: 180,
      );

      await repo.saveSession(session1);
      await repo.saveSession(session2);

      await repo.deleteSession('test-1');

      final remaining = await repo.getSessions();
      expect(remaining.length, 1);
      expect(remaining.first.id, 'test-2');
    });

    test('clears all sessions', () async {
      final session = SessionRecord(
        id: 'test-1',
        exerciseTitle: 'Phrase Wave',
        textTitle: 'Sample',
        timestamp: DateTime(2026, 10, 1),
        wpm: 215,
        questionsCorrect: 3,
        totalQuestions: 3,
        readingDurationSeconds: 50,
        wordCount: 180,
      );
      await repo.saveSession(session);
      await repo.clearSessions();

      final sessions = await repo.getSessions();
      expect(sessions, isEmpty);
    });
  });
}
