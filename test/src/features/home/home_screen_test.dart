import 'package:fast_reading_learner/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts on the home screen', (tester) async {
    await tester.pumpWidget(const FastReadingApp());

    expect(find.text(FastReadingApp.title), findsOneWidget);
    expect(find.text('Train your reading speed'), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
  });

  testWidgets('Exercises opens from home', (tester) async {
    await tester.pumpWidget(const FastReadingApp());

    await tester.tap(find.widgetWithText(FilledButton, 'Exercises'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Exercises'), findsOneWidget);
    await tester.tap(find.text('Read & Check'));
    await tester.pumpAndSettle();
    expect(find.text('Rounds are coming soon.'), findsOneWidget);
  });
}
