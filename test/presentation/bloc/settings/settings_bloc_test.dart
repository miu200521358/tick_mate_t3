import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tick_mate_t3/data/datasources/local/secure_storage_datasource.dart';
import 'package:tick_mate_t3/data/datasources/remote/gemini_api_datasource.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_event.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_state.dart';

// Mock classes
class MockSecureStorageDataSource extends Mock
    implements SecureStorageDataSource {}

class MockGeminiApiDataSource extends Mock implements GeminiApiDataSource {}

void main() {
  late SettingsBloc settingsBloc;
  late MockSecureStorageDataSource mockSecureStorage;
  late MockGeminiApiDataSource mockGeminiApiDataSource;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    mockSecureStorage = MockSecureStorageDataSource();
    mockGeminiApiDataSource = MockGeminiApiDataSource();
    settingsBloc = SettingsBloc(mockSecureStorage, mockGeminiApiDataSource);
  });

  tearDown(() {
    settingsBloc.close();
  });

  group('SettingsBloc', () {
    const testApiKey = 'test_api_key_123';

    test('初期状態はSettingsInitialであること', () {
      expect(settingsBloc.state, isA<SettingsInitial>());
    });

    group('SettingsInitialized', () {
      test('APIキーが存在する場合、SettingsLoadedを発行すること', () async {
        // Arrange
        when(
          () => mockSecureStorage.getGeminiApiKey(),
        ).thenAnswer((_) async => testApiKey);

        // Act
        settingsBloc.add(const SettingsInitialized());

        // Assert
        await expectLater(
          settingsBloc.stream,
          emitsInOrder([
            isA<SettingsLoading>(),
            isA<SettingsLoaded>().having(
              (state) => state.geminiApiKey,
              'geminiApiKey',
              testApiKey,
            ),
          ]),
        );
      });

      test('APIキーが存在しない場合、nullのgeminiApiKeyを持つSettingsLoadedを発行すること', () async {
        // Arrange
        when(
          () => mockSecureStorage.getGeminiApiKey(),
        ).thenAnswer((_) async => null);

        // Act
        settingsBloc.add(const SettingsInitialized());

        // Assert
        await expectLater(
          settingsBloc.stream,
          emitsInOrder([
            isA<SettingsLoading>(),
            isA<SettingsLoaded>().having(
              (state) => state.geminiApiKey,
              'geminiApiKey',
              null,
            ),
          ]),
        );
      });

      test('例外が発生した場合、SettingsErrorを発行すること', () async {
        // Arrange
        when(
          () => mockSecureStorage.getGeminiApiKey(),
        ).thenThrow(Exception('テストエラー'));

        // Act
        settingsBloc.add(const SettingsInitialized());

        // Assert
        await expectLater(
          settingsBloc.stream,
          emitsInOrder([isA<SettingsLoading>(), isA<SettingsError>()]),
        );
      });
    });

    group('GeminiApiKeySaved', () {
      test('APIキーが正常に保存された場合、SettingsLoadedを発行すること', () async {
        // Arrange
        when(
          () => mockSecureStorage.saveGeminiApiKey(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockSecureStorage.getGeminiApiKey(),
        ).thenAnswer((_) async => testApiKey);

        // Act
        settingsBloc.add(const GeminiApiKeySaved(apiKey: testApiKey));

        // Assert
        await expectLater(
          settingsBloc.stream,
          emitsInOrder([
            isA<SettingsLoading>(),
            isA<SettingsLoaded>().having(
              (state) => state.geminiApiKey,
              'geminiApiKey',
              testApiKey,
            ),
          ]),
        );

        verify(() => mockSecureStorage.saveGeminiApiKey(testApiKey)).called(1);
      });

      test('例外が発生した場合、SettingsErrorを発行すること', () async {
        // Arrange
        when(
          () => mockSecureStorage.saveGeminiApiKey(any()),
        ).thenThrow(Exception('テストエラー'));

        // Act
        settingsBloc.add(const GeminiApiKeySaved(apiKey: testApiKey));

        // Assert
        await expectLater(
          settingsBloc.stream,
          emitsInOrder([isA<SettingsLoading>(), isA<SettingsError>()]),
        );
      });
    });

    group('GeminiApiKeyDeleted', () {
      test(
        'APIキーが正常に削除された場合、nullのgeminiApiKeyを持つSettingsLoadedを発行すること',
        () async {
          // Arrange
          when(
            () => mockSecureStorage.deleteGeminiApiKey(),
          ).thenAnswer((_) async => {});

          // Act
          settingsBloc.add(const GeminiApiKeyDeleted());

          // Assert
          await expectLater(
            settingsBloc.stream,
            emitsInOrder([
              isA<SettingsLoading>(),
              isA<SettingsLoaded>().having(
                (state) => state.geminiApiKey,
                'geminiApiKey',
                null,
              ),
            ]),
          );

          verify(() => mockSecureStorage.deleteGeminiApiKey()).called(1);
        },
      );

      test('例外が発生した場合、SettingsErrorを発行すること', () async {
        // Arrange
        when(
          () => mockSecureStorage.deleteGeminiApiKey(),
        ).thenThrow(Exception('テストエラー'));

        // Act
        settingsBloc.add(const GeminiApiKeyDeleted());

        // Assert
        await expectLater(
          settingsBloc.stream,
          emitsInOrder([isA<SettingsLoading>(), isA<SettingsError>()]),
        );
      });
    });

    group('GeminiApiKeyTested', () {
      test('APIキーのテストが成功した場合、成功状態のSettingsLoadedを発行すること', () async {
        // Arrange
        const testResponse = 'API key is valid';
        when(
          () => mockSecureStorage.saveGeminiApiKey(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockGeminiApiDataSource.generateMessage(
            prompt: any(named: 'prompt'),
            maxTokens: any(named: 'maxTokens'),
          ),
        ).thenAnswer((_) async => testResponse);

        // 初期状態をSettingsLoadedにする
        settingsBloc.emit(const SettingsLoaded(geminiApiKey: testApiKey));

        // Act
        settingsBloc.add(const GeminiApiKeyTested(apiKey: testApiKey));

        // Assert
        await expectLater(
          settingsBloc.stream,
          emitsInOrder([
            isA<SettingsLoaded>().having(
              (state) => state.isTesting,
              'isTesting',
              true,
            ),
            isA<SettingsLoaded>()
                .having(
                  (state) => state.geminiApiKey,
                  'geminiApiKey',
                  testApiKey,
                )
                .having((state) => state.isTesting, 'isTesting', false)
                .having((state) => state.testResult, 'testResult', testResponse)
                .having((state) => state.testSuccess, 'testSuccess', true),
          ]),
        );

        verify(() => mockSecureStorage.saveGeminiApiKey(testApiKey)).called(1);
        verify(
          () => mockGeminiApiDataSource.generateMessage(
            prompt: any(named: 'prompt'),
            maxTokens: any(named: 'maxTokens'),
          ),
        ).called(1);
      });

      test('APIキーのテストが失敗した場合、失敗状態のSettingsLoadedを発行すること', () async {
        // Arrange
        final testException = Exception('無効なAPIキー');
        when(
          () => mockSecureStorage.saveGeminiApiKey(any()),
        ).thenAnswer((_) async => {});
        when(
          () => mockGeminiApiDataSource.generateMessage(
            prompt: any(named: 'prompt'),
            maxTokens: any(named: 'maxTokens'),
          ),
        ).thenThrow(testException);

        // 初期状態をSettingsLoadedにする
        settingsBloc.emit(const SettingsLoaded(geminiApiKey: testApiKey));

        // Act
        settingsBloc.add(const GeminiApiKeyTested(apiKey: testApiKey));

        // Assert
        await expectLater(
          settingsBloc.stream,
          emitsInOrder([
            isA<SettingsLoaded>().having(
              (state) => state.isTesting,
              'isTesting',
              true,
            ),
            isA<SettingsLoaded>()
                .having(
                  (state) => state.geminiApiKey,
                  'geminiApiKey',
                  testApiKey,
                )
                .having((state) => state.isTesting, 'isTesting', false)
                .having(
                  (state) => state.testResult,
                  'testResult',
                  testException.toString(),
                )
                .having((state) => state.testSuccess, 'testSuccess', false),
          ]),
        );

        verify(() => mockSecureStorage.saveGeminiApiKey(testApiKey)).called(1);
        verify(
          () => mockGeminiApiDataSource.generateMessage(
            prompt: any(named: 'prompt'),
            maxTokens: any(named: 'maxTokens'),
          ),
        ).called(1);
      });
    });
  });
}
