import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/session_record.dart';
import 'session_repository.dart';

/// SharedPreferences-based offline storage for sessions.
class SharedPreferencesSessionRepository implements SessionRepository {
  SharedPreferencesSessionRepository({this.preferences});

  static const String _storageKey = 'fast_reading_sessions_v1';

  SharedPreferences? preferences;

  Future<SharedPreferences> _getPrefs() async {
    return preferences ??= await SharedPreferences.getInstance();
  }

  @override
  Future<List<SessionRecord>> getSessions() async {
    final prefs = await _getPrefs();
    final jsonList = prefs.getStringList(_storageKey);
    if (jsonList == null || jsonList.isEmpty) {
      return <SessionRecord>[];
    }

    final sessions = <SessionRecord>[];
    for (final item in jsonList) {
      try {
        final map = json.decode(item) as Map<String, dynamic>;
        sessions.add(SessionRecord.fromMap(map));
      } catch (_) {
        // Skip corrupted entries
      }
    }
    return sessions;
  }

  @override
  Future<void> saveSession(SessionRecord session) async {
    final prefs = await _getPrefs();
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == session.id);
    sessions.add(session);

    final jsonList = sessions.map((s) => s.toJson()).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  @override
  Future<void> deleteSession(String id) async {
    final prefs = await _getPrefs();
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == id);

    final jsonList = sessions.map((s) => s.toJson()).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  @override
  Future<void> clearSessions() async {
    final prefs = await _getPrefs();
    await prefs.remove(_storageKey);
  }
}
