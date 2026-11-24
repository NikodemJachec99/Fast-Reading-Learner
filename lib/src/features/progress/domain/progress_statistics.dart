import 'progress_period.dart';
import 'session_record.dart';

/// Represents a single day's datapoint in the reading speed chart.
class DailySpeedPoint {
  const DailySpeedPoint({
    required this.date,
    required this.dayLabel,
    required this.wpm,
    required this.hasPassed,
    required this.hasFailedOnly,
  });

  final DateTime date;
  final String dayLabel;

  /// Null if no sessions occurred on this day.
  /// Days without passed sessions are never represented as zero WPM.
  final int? wpm;

  /// True if at least one session on this day passed the comprehension test.
  final bool hasPassed;

  /// True if all sessions on this day were below the 2/3 passing threshold.
  final bool hasFailedOnly;

  bool get hasData => wpm != null;
}

/// Statistics computed from a set of sessions for a specific time period.
class ProgressStatistics {
  const ProgressStatistics({
    required this.period,
    required this.filteredSessions,
    required this.completedSessionsCount,
    required this.averagePassedWpm,
    required this.totalQuestionsCorrect,
    required this.totalQuestionsAsked,
    required this.trendWpm,
    required this.chartPoints,
  });

  final ProgressPeriod period;

  /// Sessions in the selected period, sorted newest first.
  final List<SessionRecord> filteredSessions;

  /// Total number of completed sessions in the selected period.
  final int completedSessionsCount;

  /// Average WPM calculated from passed sessions only. Null if no passed sessions.
  final int? averagePassedWpm;

  /// Total correct answers across all completed tests (passed + failed).
  final int totalQuestionsCorrect;

  /// Total questions asked across all completed tests (passed + failed).
  final int totalQuestionsAsked;

  /// Difference in average passed WPM between the current and preceding period.
  /// Null if insufficient data exists in either period.
  final int? trendWpm;

  /// Daily data points for the reading speed chart.
  final List<DailySpeedPoint> chartPoints;

  /// Calculates statistics from [sessions] for the given [period].
  /// [referenceDate] defaults to current DateTime if not provided (useful for tests).
  factory ProgressStatistics.compute({
    required List<SessionRecord> sessions,
    required ProgressPeriod period,
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final periodDuration = Duration(days: period.days);

    // Current period start: beginning of (now - (days - 1)) day
    final currentPeriodStart = todayStart.subtract(
      Duration(days: period.days - 1),
    );
    final precedingPeriodStart = currentPeriodStart.subtract(periodDuration);

    // Filter sessions in current period (completed tests only for statistics)
    final currentPeriodSessions = <SessionRecord>[];
    final precedingPeriodSessions = <SessionRecord>[];

    for (final s in sessions) {
      if (!s.isCompleted) continue;

      if (!s.timestamp.isBefore(currentPeriodStart) &&
          !s.timestamp.isAfter(now)) {
        currentPeriodSessions.add(s);
      } else if (!s.timestamp.isBefore(precedingPeriodStart) &&
          s.timestamp.isBefore(currentPeriodStart)) {
        precedingPeriodSessions.add(s);
      }
    }

    // Sort current period newest first for history
    currentPeriodSessions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Rule: Completed session count includes only sessions with completed tests
    final completedCount = currentPeriodSessions.length;

    // Rule: Average WPM includes passed sessions only
    final passedSessions = currentPeriodSessions
        .where((s) => s.isPassed)
        .toList();
    final int? avgPassedWpm = passedSessions.isNotEmpty
        ? (passedSessions.map((s) => s.wpm).reduce((a, b) => a + b) /
                  passedSessions.length)
              .round()
        : null;

    // Rule: Comprehension includes all completed tests, whether passed or failed
    var correctCount = 0;
    var totalQuestionsCount = 0;
    for (final s in currentPeriodSessions) {
      correctCount += s.questionsCorrect;
      totalQuestionsCount += s.totalQuestions;
    }

    // Rule: Trend indicator comparing current with preceding period using passed sessions only
    final precedingPassed = precedingPeriodSessions
        .where((s) => s.isPassed)
        .toList();
    int? trend;
    if (avgPassedWpm != null && precedingPassed.isNotEmpty) {
      final precedingAvg =
          (precedingPassed.map((s) => s.wpm).reduce((a, b) => a + b) /
                  precedingPassed.length)
              .round();
      trend = avgPassedWpm - precedingAvg;
    }

    // Chart points: one point per day in the period
    final chartPoints = _buildChartPoints(
      sessions: currentPeriodSessions,
      period: period,
      todayStart: todayStart,
    );

    return ProgressStatistics(
      period: period,
      filteredSessions: currentPeriodSessions,
      completedSessionsCount: completedCount,
      averagePassedWpm: avgPassedWpm,
      totalQuestionsCorrect: correctCount,
      totalQuestionsAsked: totalQuestionsCount,
      trendWpm: trend,
      chartPoints: chartPoints,
    );
  }

  static List<DailySpeedPoint> _buildChartPoints({
    required List<SessionRecord> sessions,
    required ProgressPeriod period,
    required DateTime todayStart,
  }) {
    final points = <DailySpeedPoint>[];
    const weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final totalDays = period.days;
    for (var i = totalDays - 1; i >= 0; i--) {
      final day = todayStart.subtract(Duration(days: i));
      final nextDay = day.add(const Duration(days: 1));

      // Find sessions on this day
      final daySessions = sessions.where((s) {
        return !s.timestamp.isBefore(day) && s.timestamp.isBefore(nextDay);
      }).toList();

      final passedOnDay = daySessions.where((s) => s.isPassed).toList();
      final failedOnDay = daySessions.where((s) => !s.isPassed).toList();

      int? dayWpm;
      bool hasPassed = false;
      bool hasFailedOnly = false;

      if (passedOnDay.isNotEmpty) {
        dayWpm =
            (passedOnDay.map((s) => s.wpm).reduce((a, b) => a + b) /
                    passedOnDay.length)
                .round();
        hasPassed = true;
      } else if (failedOnDay.isNotEmpty) {
        dayWpm =
            (failedOnDay.map((s) => s.wpm).reduce((a, b) => a + b) /
                    failedOnDay.length)
                .round();
        hasFailedOnly = true;
      }

      final String dayLabel;
      if (period == ProgressPeriod.sevenDays) {
        dayLabel = weekdayNames[day.weekday - 1];
      } else {
        // For 30-day view, show day number e.g. "12" or "12/5"
        dayLabel = '${day.day}';
      }

      points.add(
        DailySpeedPoint(
          date: day,
          dayLabel: dayLabel,
          wpm: dayWpm,
          hasPassed: hasPassed,
          hasFailedOnly: hasFailedOnly,
        ),
      );
    }

    return points;
  }
}
