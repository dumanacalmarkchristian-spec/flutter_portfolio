import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_portfolio/main.dart';
import 'package:flutter_portfolio/models/app_state.dart';

Widget buildApp() {
  return ChangeNotifierProvider(
    create: (_) => AppState(),
    child: const PortfolioApp(),
  );
}

void main() {
  testWidgets('Home dashboard renders activities', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Lab Portfolio'), findsOneWidget);
    expect(find.text('Activity 1: Counter Lab'), findsOneWidget);
    expect(find.text('Activity 2: Task Input Lab'), findsOneWidget);
  });

  testWidgets('Counter increments and decrements', (WidgetTester tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Activity 1: Counter Lab'));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Increase'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('Decrease'));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}