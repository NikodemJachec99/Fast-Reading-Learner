import 'dart:convert';

import '../../../core/reading/reading_speed.dart';

/// Represents a single reading practice session.
class SessionRecord {
  const SessionRecord({
    required this.id,
    required this.exerciseTitle,
    required this.textTitle,
    required this.timestamp,
    required this.wpm,
    required this.questionsCorrect,
    required this.totalQuestions,
    required this.readingDurationSeconds,
    required this.wordCount,
    this.isCompleted = true,
  });

  /// Factory constructor that calculates [wpm] using [ReadingSpeed.fromSession].
  factory SessionRecord.create({
    required String id,
    required String exerciseTitle,
    required String textTitle,
    required DateTime timestamp,
    required int questionsCorrect,
    required int totalQuestions,
    required int readingDurationSeconds,
    required int wordCount,
    bool isCompleted = true,
    int? customWpm,
  }) {
    final computedWpm =
        customWpm ??
        (readingDurationSeconds > 0
            ? ReadingSpeed.fromSession(
                wordsRead: wordCount,
                elapsed: Duration(seconds: readingDurationSeconds),
              ).wordsPerMinute
            : 0);

    return SessionRecord(
      id: id,
      exerciseTitle: exerciseTitle,
      textTitle: textTitle,
      timestamp: timestamp,
      wpm: computedWpm,
      questionsCorrect: questionsCorrect,
      totalQuestions: totalQuestions,
      readingDurationSeconds: readingDurationSeconds,
      wordCount: wordCount,
      isCompleted: isCompleted,
    );
  }

  final String id;
  final String exerciseTitle;
  final String textTitle;
  final DateTime timestamp;
  final int wpm;
  final int questionsCorrect;
  final int totalQuestions;
  final int readingDurationSeconds;
  final int wordCount;
  final bool isCompleted;

  /// Passing rule:
  /// A session passes when the user answers at least 2/3 of the questions correctly.
  /// Uses integer arithmetic: `questionsCorrect * 3 >= totalQuestions * 2`.
  bool get isPassed =>
      isCompleted &&
      totalQuestions > 0 &&
      questionsCorrect * 3 >= totalQuestions * 2;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseTitle': exerciseTitle,
      'textTitle': textTitle,
      'timestamp': timestamp.toIso8601String(),
      'wpm': wpm,
      'questionsCorrect': questionsCorrect,
      'totalQuestions': totalQuestions,
      'readingDurationSeconds': readingDurationSeconds,
      'wordCount': wordCount,
      'isCompleted': isCompleted,
    };
  }

  factory SessionRecord.fromMap(Map<String, dynamic> map) {
    return SessionRecord(
      id: map['id'] as String,
      exerciseTitle: map['exerciseTitle'] as String,
      textTitle: map['textTitle'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      wpm: (map['wpm'] as num).toInt(),
      questionsCorrect: (map['questionsCorrect'] as num).toInt(),
      totalQuestions: (map['totalQuestions'] as num).toInt(),
      readingDurationSeconds: (map['readingDurationSeconds'] as num).toInt(),
      wordCount: (map['wordCount'] as num).toInt(),
      isCompleted: map['isCompleted'] as bool? ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionRecord.fromJson(String source) =>
      SessionRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionRecord &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
