// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tick_mate/domain/entities/timer_entity.dart';
import 'package:tick_mate/domain/usecases/timer/create_timer_usecase.dart';
import 'package:tick_mate/domain/usecases/timer/get_timers_usecase.dart';
import 'package:tick_mate/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate/presentation/bloc/app/app_state.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_state.dart';
import 'package:tick_mate/presentation/screens/home/home_screen.dart';

// モッククラス
class MockAppBloc extends Mock implements AppBloc {
  @override
  Stream<AppState> get stream => Stream.fromIterable([const AppInitial()]);
}

class MockTimerBloc extends Mock implements TimerBloc {
  final now = DateTime.now();

  @override
  Stream<TimerState> get stream => Stream.fromIterable([
    TimerLoaded(
      timers: [
        TimerEntity(
          id: '1',
          title: 'テストタイマー',
          dateTime: null,
          timeRange: '9:00-10:00',
          timerType: TimerType.schedule,
          repeatType: RepeatType.none,
          characterIds: ['test_character'],
          notificationSound: null,
          location: null,
          useCurrentLocation: false,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    ),
  ]);
}

class MockGetTimersUseCase extends Mock implements GetTimersUseCase {}

class MockCreateTimerUseCase extends Mock implements CreateTimerUseCase {}

void main() {
  late MockAppBloc appBloc;
  late MockTimerBloc timerBloc;

  setUp(() {
    appBloc = MockAppBloc();
    timerBloc = MockTimerBloc();

    // AppBlocの状態をモック
    when(() => appBloc.state).thenReturn(const AppInitial());

    // TimerBlocの状態をモック
    when(() => timerBloc.state).thenReturn(const TimerLoaded(timers: []));
  });

  testWidgets('Home screen renders correctly with BLoC', (
    WidgetTester tester,
  ) async {
    // テストウィジェットを構築
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ja')],
        locale: const Locale('ja'), // Use Japanese for tests
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>.value(value: appBloc),
            BlocProvider<TimerBloc>.value(value: timerBloc),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    // UIが更新されるのを待つ
    await tester.pumpAndSettle();

    // アプリタイトルが表示されていることを確認
    expect(find.text('TickMate'), findsOneWidget);

    // ボトムナビゲーションバーのアイテムを確認
    // ボトムナビゲーションバーのアイテムを確認 - ローカライズされたテキストを使用
    // テスト時には日本語ロケールを使用しているため、日本語のテキストを期待する
    expect(
      find.text('タイマー'),
      findsOneWidget,
    ); // AppLocalizations.of(context)!.timerTab
    expect(
      find.text('通知履歴'),
      findsOneWidget,
    ); // AppLocalizations.of(context)!.notificationTab
    expect(
      find.text('キャラクター'),
      findsOneWidget,
    ); // AppLocalizations.of(context)!.characterTab
    expect(
      find.text('設定'),
      findsOneWidget,
    ); // AppLocalizations.of(context)!.settingsTab

    // 追加ボタンが存在することを確認
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Home screen shows timer list when timers are available', (
    WidgetTester tester,
  ) async {
    // タイマーリストがある状態をモック
    final now = DateTime.now();
    final timers = [
      TimerEntity(
        id: '1',
        title: 'テストタイマー',
        dateTime: null,
        timeRange: '9:00-10:00',
        timerType: TimerType.schedule,
        repeatType: RepeatType.none,
        characterIds: ['test_character'],
        notificationSound: null,
        location: null,
        useCurrentLocation: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    when(() => timerBloc.state).thenReturn(TimerLoaded(timers: timers));

    // テストウィジェットを構築
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ja')],
        locale: const Locale('ja'), // Use Japanese for tests
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>.value(value: appBloc),
            BlocProvider<TimerBloc>.value(value: timerBloc),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    // UIが更新されるのを待つ
    await tester.pumpAndSettle();

    // タイマータイトルが表示されていることを確認
    expect(find.text('テストタイマー'), findsOneWidget);

    // タイマーの時間範囲が表示されていることを確認
    expect(find.text('時間範囲: 9:00-10:00'), findsOneWidget);

    // タイマータイプが表示されていることを確認
    expect(find.text('タイプ: schedule'), findsOneWidget);
  });
}
