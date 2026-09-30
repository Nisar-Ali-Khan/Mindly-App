import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindly/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MindlyApp()));

    // Verify that onboarding starts
    expect(find.text('Welcome to Mindly'), findsOneWidget);
  });
}
