import 'package:fast_reading_learner/src/features/exercises/exercise.dart';
import 'package:fast_reading_learner/src/features/exercises/exercises_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder _chip(String label) => find.widgetWithText(ChoiceChip, label);

void main() {
  testWidgets('filters exercises by category and returns to All', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const MaterialApp(home: ExercisesScreen()));

    expect(tester.widget<ChoiceChip>(_chip('All')).selected, isTrue);
    expect(find.text('Read & Check'), findsOneWidget);
    expect(find.text('Meaning Bridges'), findsOneWidget);

    const titlesByCategory = {
      'Reading': ['Read & Check', 'Phrase Wave', 'Fading Text'],
      'Comprehension': [
        'Meaning Bridges',
        'Info Hunter',
        'Shorten the Paragraph',
      ],
      'Memory': ['Memory Map', 'Associations'],
    };
    for (final category in titlesByCategory.keys) {
      await tester.tap(_chip(category));
      await tester.pumpAndSettle();

      expect(tester.widget<ChoiceChip>(_chip(category)).selected, isTrue);
      expect(tester.widget<ChoiceChip>(_chip('All')).selected, isFalse);
      for (final entry in titlesByCategory.entries) {
        for (final title in entry.value) {
          expect(
            find.text(title),
            entry.key == category ? findsOneWidget : findsNothing,
          );
        }
      }
    }

    await tester.tap(_chip('All'));
    await tester.pumpAndSettle();

    expect(tester.widget<ChoiceChip>(_chip('All')).selected, isTrue);
    expect(find.text('Read & Check'), findsOneWidget);
    expect(find.text('Meaning Bridges'), findsOneWidget);
    for (final exercise in Exercise.values) {
      final title = find.text(exercise.title);
      await tester.scrollUntilVisible(title, 150);
      await tester.pumpAndSettle();
      expect(title.hitTestable(), findsOneWidget);
    }

    expect(_chip('Memory').hitTestable(), findsOneWidget);
    await tester.tap(_chip('Memory'));
    await tester.pumpAndSettle();

    expect(find.text('Memory Map').hitTestable(), findsOneWidget);
    expect(find.text('Associations').hitTestable(), findsOneWidget);
    expect(find.text('Read & Check'), findsNothing);
  });

  testWidgets('shows levels, forwards card taps and keeps 06–08 locked', (
    tester,
  ) async {
    final started = <Exercise>[];
    await tester.pumpWidget(
      MaterialApp(
        home: ExercisesScreen(
          levels: const {Exercise.readAndCheck: ExerciseLevel.two},
          onStartRound: started.add,
        ),
      ),
    );

    final levelCard = find.widgetWithText(Card, 'Read & Check');
    expect(
      find.descendant(of: levelCard, matching: find.text('01')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: levelCard, matching: find.text('Level 2')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: levelCard, matching: find.byIcon(Icons.circle)),
      findsNWidgets(2),
    );
    expect(
      find.descendant(
        of: levelCard,
        matching: find.byIcon(Icons.circle_outlined),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.widgetWithText(Card, 'Phrase Wave'),
        matching: find.text('New'),
      ),
      findsOneWidget,
    );

    for (final exercise in Exercise.values) {
      await tester.tap(_chip(exercise.category.label));
      await tester.pumpAndSettle();
      final title = find.text(exercise.title);

      if (exercise.isLocked) {
        final card = find.widgetWithText(Card, exercise.title);
        expect(
          find.descendant(of: card, matching: find.byIcon(Icons.lock_outline)),
          findsOneWidget,
        );
        expect(
          find.descendant(of: card, matching: find.text('Locked')),
          findsOneWidget,
        );
      }
      await tester.tap(title);
    }

    expect(started, [
      Exercise.readAndCheck,
      Exercise.phraseWave,
      Exercise.meaningBridges,
      Exercise.infoHunter,
      Exercise.memoryMap,
    ]);
  });
}
