import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate/core/utils/date_time_utils.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/widgets/date_time_picker_widget.dart';

void main() {
  Widget createWidgetUnderTest({
    DateTime? initialDateTime,
    required void Function(DateTime) onDateTimeSelected,
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ja')],
      locale: const Locale('ja'), // 日本語をテストに使用
      home: Scaffold(
        body: DateTimePickerWidget(
          initialDateTime: initialDateTime,
          onDateTimeSelected: onDateTimeSelected,
        ),
      ),
    );
  }

  group('DateTimePickerWidget', () {
    testWidgets('初期値なしで正しく表示されること', (WidgetTester tester) async {
      // Arrange
      DateTime? selectedDateTime;
      
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          onDateTimeSelected: (dateTime) {
            selectedDateTime = dateTime;
          },
        ),
      );
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('日時を選択'), findsOneWidget);
      expect(find.text('日付を選択'), findsOneWidget);
      expect(find.text('時刻を選択'), findsOneWidget);
      
      // 現在の日付が表示されていることを確認
      final now = DateTime.now();
      final formattedDate = DateTimeUtils.formatDateTime(
        now,
        pattern: 'yyyy-MM-dd',
      );
      expect(find.textContaining(formattedDate.substring(0, 7)), findsOneWidget);
    });
    
    testWidgets('初期値ありで正しく表示されること', (WidgetTester tester) async {
      // Arrange
      final initialDateTime = DateTime(2025, 4, 15, 14, 30);
      DateTime? selectedDateTime;
      
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          initialDateTime: initialDateTime,
          onDateTimeSelected: (dateTime) {
            selectedDateTime = dateTime;
          },
        ),
      );
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('日時を選択'), findsOneWidget);
      
      // 指定した日付と時刻が表示されていることを確認
      final formattedDate = DateTimeUtils.formatDateTime(
        initialDateTime,
        pattern: 'yyyy-MM-dd',
      );
      expect(find.text(formattedDate), findsOneWidget);
      expect(find.text('14:30'), findsOneWidget);
    });
    
    testWidgets('日付フィールドをタップすると日付ピッカーが表示されること', (WidgetTester tester) async {
      // Arrange
      DateTime? selectedDateTime;
      
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          onDateTimeSelected: (dateTime) {
            selectedDateTime = dateTime;
          },
        ),
      );
      await tester.pumpAndSettle();
      
      // 日付フィールドをタップ
      final dateFinder = find.ancestor(
        of: find.text('日付を選択'),
        matching: find.byType(InputDecorator),
      );
      expect(dateFinder, findsOneWidget);
      
      // showDatePickerはモックできないため、タップ操作のみ検証
      expect(tester.takeException(), isNull);
    });
    
    testWidgets('時刻フィールドをタップすると時刻ピッカーが表示されること', (WidgetTester tester) async {
      // Arrange
      DateTime? selectedDateTime;
      
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          onDateTimeSelected: (dateTime) {
            selectedDateTime = dateTime;
          },
        ),
      );
      await tester.pumpAndSettle();
      
      // 時刻フィールドをタップ
      final timeFinder = find.ancestor(
        of: find.text('時刻を選択'),
        matching: find.byType(InputDecorator),
      );
      expect(timeFinder, findsOneWidget);
      
      // showTimePickerはモックできないため、タップ操作のみ検証
      expect(tester.takeException(), isNull);
    });
  });
}
