import 'package:fast_reading_learner/src/core/theme/app_theme.dart';
import 'package:fast_reading_learner/src/features/progress/data/demo_sessions.dart';
import 'package:fast_reading_learner/src/features/progress/domain/session_record.dart';
import 'package:fast_reading_learner/src/features/progress/presentation/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final refDate = DateTime(2026, 10, 15, 12, 0);

  Widget createWidgetUnderTest({List<SessionRecord>? initialSessions}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: ProgressScreen(
        initialSessions: initialSessions,
        referenceDate: refDate,
      ),
    );
  }

  group('ProgressScreen Widget Tests', () {
    testWidgets(
      'renders header, 3 summary cards, chart, and empty state when no sessions',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(initialSessions: []));
        await tester.pumpAndSettle();

        // Title & Period Selector
        expect(find.text('Progress'), findsOneWidget);
        expect(find.text('7 days'), findsOneWidget);
        expect(find.text('30 days'), findsOneWidget);

        // Summary Card Titles
        expect(find.text('Avg. speed'), findsOneWidget);
        expect(find.text('Comprehension'), findsOneWidget);
        expect(find.text('Sessions'), findsOneWidget);

        // Chart
        expect(find.text('Reading speed'), findsOneWidget);
        expect(find.text('test passed'), findsOneWidget);
        expect(find.text('below 2/3'), findsOneWidget);

        // Empty State
        expect(find.text('No sessions in this period'), findsOneWidget);
      },
    );

    testWidgets('renders session cards and calculates metrics when populated', (
      tester,
    ) async {
      final sample = DemoSessions.createSampleSessions(referenceDate: refDate);

      await tester.pumpWidget(createWidgetUnderTest(initialSessions: sample));
      await tester.pumpAndSettle();

      // Check session card titles from Slide 12
      expect(
        find.textContaining('Phrase Wave · The New Library'),
        findsOneWidget,
      );
      expect(find.textContaining('Read & Check · Rivers'), findsOneWidget);
      expect(find.textContaining('Phrase Wave · Bees'), findsOneWidget);

      // Check failed session remains visible in history
      expect(find.text('1/3'), findsOneWidget);

      // Check trend pill (+38 wpm from sample)
      expect(find.text('+38 wpm'), findsOneWidget);
    });

    testWidgets('switching between 7 days and 30 days updates selection', (
      tester,
    ) async {
      final sample = DemoSessions.createSampleSessions(referenceDate: refDate);

      await tester.pumpWidget(createWidgetUnderTest(initialSessions: sample));
      await tester.pumpAndSettle();

      // Tap 30 days
      await tester.tap(find.text('30 days'));
      await tester.pumpAndSettle();

      // Verify widget remains intact and responsive
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Reading speed'), findsOneWidget);
    });
  });
}
