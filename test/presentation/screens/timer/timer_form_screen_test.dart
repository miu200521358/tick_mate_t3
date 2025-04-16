import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:mocktail/mocktail.dart';
import 'package:tick_mate/core/services/error_handler_service.dart'; // Import real service
import 'package:tick_mate/domain/entities/timer_entity.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_event.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_state.dart';
import 'package:tick_mate/presentation/screens/timer/timer_form_screen.dart';
import 'package:tick_mate/presentation/widgets/date_time_picker_widget.dart';

// Mock class
class MockTimerBloc extends Mock implements TimerBloc {
  final _stateController = StreamController<TimerState>.broadcast();

  @override
  Stream<TimerState> get stream => _stateController.stream;

  void emitState(TimerState state) {
    when(() => this.state).thenReturn(state);
    _stateController.add(state);
  }

  @override
  Future<void> close() async {
    await _stateController.close();
    return Future.value();
  }
}

// Mock ErrorHandlerService
class MockErrorHandlerService extends Mock implements ErrorHandlerService {}

void main() {
  late MockTimerBloc mockTimerBloc;

  setUpAll(() {
    registerFallbackValue(
      const TimerCreated(
        title: 'test',
        timeSpecificationType: TimeSpecificationType.dateTime, // <<< 追加
        timerType: TimerType.schedule,
        repeatType: RepeatType.none,
        characterIds: ['test'],
      ),
    );
    // Register mock ErrorHandlerService once for all tests in this file
    GetIt.instance.registerSingleton<ErrorHandlerService>(
      MockErrorHandlerService(),
    );
  });

  tearDownAll(() {
    // Unregister mock ErrorHandlerService once after all tests in this file
    GetIt.instance.unregister<ErrorHandlerService>();
  });

  setUp(() {
    mockTimerBloc = MockTimerBloc();
    when(() => mockTimerBloc.state).thenReturn(const TimerInitial());
  });

  tearDown(() {
    reset(mockTimerBloc);
  });

  Widget createWidgetUnderTest({TimerEntity? initialTimer}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ja')],
      locale: const Locale('ja'), // 日本語をテストに使用
      home: BlocProvider<TimerBloc>.value(
        value: mockTimerBloc,
        child: TimerFormScreen(initialTimer: initialTimer),
      ),
    );
  }

  group('TimerFormScreen', () {
    testWidgets('初期状態で正しく表示されること', (WidgetTester tester) async {
      // Arrange
      when(() => mockTimerBloc.state).thenReturn(const TimerInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('タイマーを追加'), findsWidgets); // AppBarのタイトルとフォームのラベル
      expect(find.byType(DateTimePickerWidget), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('確定'), findsOneWidget);
      
      // 繰り返しパターンのドロップダウンが表示されていることを確認
      expect(find.text('繰り返しパターン'), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget.toString().contains('DropdownButtonFormField')), findsAtLeastNWidgets(2)); // 時間指定種別と繰り返しパターンの2つ
    });

    testWidgets('初期タイマーがある場合、フォームに値が設定されること', (WidgetTester tester) async {
      // Arrange
      final initialTimer = TimerEntity(
        id: 'test_id',
        title: 'テストタイマー',
        timeSpecificationType: TimeSpecificationType.dateTime, // <<< 追加
        timerType: TimerType.schedule,
        repeatType: RepeatType.none,
        characterIds: ['test_character_id'],
        dateTime: DateTime(2025, 4, 15, 14, 30),
        timeRange: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(initialTimer: initialTimer),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('テストタイマー'), findsOneWidget);
      expect(find.text('繰り返しなし'), findsOneWidget); // 初期値の繰り返しパターンが表示されていることを確認
    });

    testWidgets('タイトルを入力して送信ボタンをタップするとTimerCreatedイベントが発行されること', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockTimerBloc.state).thenReturn(const TimerInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // タイトルを入力
      await tester.enterText(find.byType(TextFormField), 'テストタイマー');
      await tester.pump();

      // 日時を選択（DateTimePickerWidgetの内部実装をモックできないため、直接選択はテストしない）
      // DateTimePickerWidgetのonDateTimeSelectedコールバックを直接呼び出す方法はないため、
      // 送信ボタンをタップしてイベント発行を検証
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockTimerBloc.add(any(that: isA<TimerCreated>()))).called(1);
    });

    testWidgets('タイトルが空の場合、バリデーションエラーが表示されること', (WidgetTester tester) async {
      // Arrange
      when(() => mockTimerBloc.state).thenReturn(const TimerInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // タイトルを空のままにする
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('タイトルを入力してください'), findsOneWidget);
    });

    testWidgets('繰り返しパターンを選択できること', (WidgetTester tester) async {
      // Arrange
      when(() => mockTimerBloc.state).thenReturn(const TimerInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // 繰り返しパターンのドロップダウンを開く
      await tester.tap(find.text('繰り返しなし'));
      await tester.pumpAndSettle();

      // 毎日を選択
      await tester.tap(find.text('毎日').last);
      await tester.pumpAndSettle();

      // タイトルを入力
      await tester.enterText(find.byType(TextFormField), 'テストタイマー');
      await tester.pump();

      // 送信ボタンをタップ
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert
      verify(() => mockTimerBloc.add(any(
        that: predicate<TimerCreated>((event) => 
          event.title == 'テストタイマー' && 
          event.repeatType == RepeatType.daily
        ),
      ))).called(1);
    });

    testWidgets('タイマー作成成功時にトーストメッセージが表示されること', (WidgetTester tester) async {
      // Arrange
      when(() => mockTimerBloc.state).thenReturn(const TimerInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // TimerCreateSuccessステートをエミット
      mockTimerBloc.emitState(const TimerCreateSuccess());
      await tester.pump();

      // Assert
      // スナックバーが表示されることを検証
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('タイマーが作成されました'), findsOneWidget);
    });
  });
}
