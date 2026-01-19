// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quiz_creator/main.dart';

void main() {
  testWidgets('Quiz App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuizApp(isLoggedIn: false));
    await tester.pumpAndSettle();

    // Verify that the login title is present (localized default is 'Xush kelibsiz!' for Uzbek)
    expect(find.textContaining('kelibsiz'), findsOneWidget);

    // Verify that the login button is present
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
