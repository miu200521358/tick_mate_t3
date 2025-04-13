import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tick_mate/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/settings/settings_bloc.dart';
import 'package:tick_mate/presentation/bloc/settings/settings_event.dart';
import 'package:tick_mate/presentation/bloc/settings/settings_state.dart';
import 'package:tick_mate/presentation/screens/settings/settings_screen.dart';

// Mock class
class MockSettingsBloc extends Mock implements SettingsBloc {
  final _stateController = StreamController<SettingsState>.broadcast();

  @override
  Stream<SettingsState> get stream => _stateController.stream;

  void emitState(SettingsState state) {
    when(() => this.state).thenReturn(state);
    _stateController.add(state);
  }

  @override
  Future<void> close() async {
    await _stateController.close();
    return Future.value();
  }
}

void main() {
  late MockSettingsBloc mockSettingsBloc;

  setUpAll(() {
    registerFallbackValue(const SettingsInitialized());
    registerFallbackValue(const GeminiApiKeySaved(apiKey: ''));
    registerFallbackValue(const GeminiApiKeyDeleted());
    registerFallbackValue(const GeminiApiKeyTested(apiKey: ''));
  });

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
    // Default state setup
    when(() => mockSettingsBloc.state).thenReturn(const SettingsInitial());
  });

  tearDown(() {
    reset(mockSettingsBloc);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ja')],
      locale: const Locale('ja'), // Use Japanese for tests
      home: BlocProvider<SettingsBloc>.value(
        value: mockSettingsBloc,
        child: const SettingsScreen(),
      ),
    );
  }

  group('SettingsScreen', () {
    testWidgets('初期化時にSettingsInitializedイベントを発行すること', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockSettingsBloc.state).thenReturn(const SettingsInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      verify(() => mockSettingsBloc.add(const SettingsInitialized())).called(1);
    });

    testWidgets('SettingsInitial状態でローディングインジケータを表示すること', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockSettingsBloc.state).thenReturn(const SettingsInitial());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('SettingsLoading状態でローディングインジケータを表示すること', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(() => mockSettingsBloc.state).thenReturn(const SettingsLoading());

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('SettingsError状態でエラーメッセージを表示すること', (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'テストエラー';
      when(
        () => mockSettingsBloc.state,
      ).thenReturn(const SettingsError(errorMessage));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.textContaining(errorMessage), findsOneWidget);
    });

    group('SettingsLoaded状態', () {
      const testApiKey = 'test_api_key_123';

      testWidgets('APIキーが存在する場合、フォームにAPIキーを表示すること', (
        WidgetTester tester,
      ) async {
        // Arrange
        final state = const SettingsLoaded(geminiApiKey: testApiKey);
        when(() => mockSettingsBloc.state).thenReturn(state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Trigger the BlocConsumer's listener
        mockSettingsBloc.emitState(state);
        await tester.pumpAndSettle();

        // Assert
        final textField = find.byType(TextField);
        expect(textField, findsOneWidget);

        // Get the controller from the TextField
        final controller = (tester.widget(textField) as TextField).controller;
        expect(controller?.text, testApiKey);
      });

      testWidgets('APIキー保存ボタンをタップするとGeminiApiKeySavedイベントを発行すること', (
        WidgetTester tester,
      ) async {
        // Arrange
        final state = const SettingsLoaded(geminiApiKey: testApiKey);
        when(() => mockSettingsBloc.state).thenReturn(state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Trigger the BlocConsumer's listener
        mockSettingsBloc.emitState(state);
        await tester.pumpAndSettle();

        // APIキーを入力
        await tester.enterText(find.byType(TextField), 'new_api_key');
        await tester.pump();

        // 保存ボタンをタップ
        await tester.tap(find.byType(ElevatedButton).first);
        await tester.pump();

        // Assert
        verify(
          () => mockSettingsBloc.add(
            const GeminiApiKeySaved(apiKey: 'new_api_key'),
          ),
        ).called(1);
      });

      testWidgets('APIキー削除ボタンをタップするとGeminiApiKeyDeletedイベントを発行すること', (
        WidgetTester tester,
      ) async {
        // Arrange
        final state = const SettingsLoaded(geminiApiKey: testApiKey);
        when(() => mockSettingsBloc.state).thenReturn(state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Trigger the BlocConsumer's listener
        mockSettingsBloc.emitState(state);
        await tester.pumpAndSettle();

        // 削除ボタンをタップ
        await tester.tap(find.byType(ElevatedButton).at(1));
        await tester.pump();

        // Assert
        verify(
          () => mockSettingsBloc.add(const GeminiApiKeyDeleted()),
        ).called(1);
      });

      testWidgets('接続テストボタンをタップするとGeminiApiKeyTestedイベントを発行すること', (
        WidgetTester tester,
      ) async {
        // Arrange
        final state = const SettingsLoaded(geminiApiKey: testApiKey);
        when(() => mockSettingsBloc.state).thenReturn(state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Trigger the BlocConsumer's listener
        mockSettingsBloc.emitState(state);
        await tester.pumpAndSettle();

        // 接続テストボタンをタップ
        await tester.tap(find.byType(ElevatedButton).at(2));
        await tester.pump();

        // Assert
        verify(
          () => mockSettingsBloc.add(
            const GeminiApiKeyTested(apiKey: testApiKey),
          ),
        ).called(1);
      });

      testWidgets('テスト中はローディングインジケータを表示すること', (WidgetTester tester) async {
        // Arrange
        final state = const SettingsLoaded(
          geminiApiKey: testApiKey,
          isTesting: true,
        );
        when(() => mockSettingsBloc.state).thenReturn(state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Trigger the BlocConsumer's listener
        mockSettingsBloc.emitState(state);
        await tester.pump(const Duration(milliseconds: 100));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('接続テスト'), findsNothing);
      });

      testWidgets('テスト成功時は成功メッセージを表示すること', (WidgetTester tester) async {
        // Arrange
        const testResult = 'API key is valid';
        final state = const SettingsLoaded(
          geminiApiKey: testApiKey,
          testResult: testResult,
          testSuccess: true,
        );
        when(() => mockSettingsBloc.state).thenReturn(state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Trigger the BlocConsumer's listener
        mockSettingsBloc.emitState(state);
        await tester.pump(const Duration(milliseconds: 100));

        // Assert
        expect(find.text('テスト成功'), findsOneWidget);
        expect(find.text(testResult), findsOneWidget);
      });

      testWidgets('テスト失敗時は失敗メッセージを表示すること', (WidgetTester tester) async {
        // Arrange
        const testResult = 'Invalid API key';
        final state = const SettingsLoaded(
          geminiApiKey: testApiKey,
          testResult: testResult,
          testSuccess: false,
        );
        when(() => mockSettingsBloc.state).thenReturn(state);

        // Act
        await tester.pumpWidget(createWidgetUnderTest());

        // Trigger the BlocConsumer's listener
        mockSettingsBloc.emitState(state);
        await tester.pump(const Duration(milliseconds: 100));

        // Assert
        expect(find.text('テスト失敗'), findsOneWidget);
        expect(find.text(testResult), findsOneWidget);
      });
    });
  });
}
