import '../domain/session_record.dart';

/// Repository interface for storing and retrieving reading practice sessions.
abstract class SessionRepository {
  /// Returns all stored sessions.
  Future<List<SessionRecord>> getSessions();

  /// Saves a new session.
  Future<void> saveSession(SessionRecord session);

  /// Deletes a session by [id].
  Future<void> deleteSession(String id);

  /// Clears all stored sessions.
  Future<void> clearSessions();
}
