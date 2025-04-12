// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tick_mate_t3/main.dart';

void main() {
  testWidgets('Home screen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('Tick Mate'), findsOneWidget);

    // Verify that the home screen text is displayed
    expect(find.text('ホーム画面'), findsOneWidget);

    // Verify that the bottom navigation bar has the expected items
    expect(find.text('タイマー'), findsOneWidget);
    expect(find.text('通知履歴'), findsOneWidget);
    expect(find.text('キャラクター'), findsOneWidget);
    expect(find.text('設定'), findsOneWidget);

    // Verify that the add button is present
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
