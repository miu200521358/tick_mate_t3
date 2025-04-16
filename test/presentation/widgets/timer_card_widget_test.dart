import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate/presentation/widgets/timer_card_widget.dart';

void main() {
  group('TimerCardWidget', () {
    testWidgets('タイマーカードが正しく表示されること', (WidgetTester tester) async {
      // Arrange
      const title = 'テストタイマー';
      final dateTime = DateTime(2025, 4, 15, 14, 30);
      const timeRange = '14:30 - 15:30';
      const timerType = 'schedule';
      const repeatType = 'daily';
      const characters = ['character1', 'character2'];
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerCardWidget(
              title: title,
              dateTime: dateTime,
              timeRange: timeRange,
              timerType: timerType,
              repeatType: repeatType,
              characters: characters,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(title), findsOneWidget);
      expect(find.text('日時: 2025/4/15 14:30'), findsOneWidget);
      expect(find.text('時間範囲: $timeRange'), findsOneWidget);
      expect(find.text('タイプ: $timerType'), findsOneWidget);
      expect(find.text('繰り返し: $repeatType'), findsOneWidget);

      // タップ動作の確認
      await tester.tap(find.byType(TimerCardWidget));
      expect(tapped, true);
    });

    testWidgets('繰り返しパターンが正しく表示されること', (WidgetTester tester) async {
      // Arrange
      const title = 'テストタイマー';
      const timerType = 'schedule';
      const repeatType = 'weekly';
      const characters = ['character1'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerCardWidget(
              title: title,
              dateTime: null,
              timeRange: null,
              timerType: timerType,
              repeatType: repeatType,
              characters: characters,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('繰り返し: $repeatType'), findsOneWidget);
    });
  });
}
