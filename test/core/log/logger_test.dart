import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/core/log/logger.dart';

// AppConfigのモック
class MockAppConfig implements AppConfig {
  @override
  String get baseUrl => 'https://mock.api.example.com';

  @override
  bool isDebugMode = true;

  @override
  bool get showBetaBanner => false;

  @override
  String get apiVersion => 'v1';
}

void main() {
  group('Logger', () {
    // Note: Testing print statements directly is tricky.
    // These tests mainly check if the methods can be called without errors.
    // A more robust test would involve mocking print or using a dedicated logging package.

    final getIt = GetIt.instance;
    final mockConfig = MockAppConfig();

    setUp(() {
      // Reset GetIt before each test
      getIt.reset();
      // Register mock config
      getIt.registerSingleton<AppConfig>(mockConfig);
      // Reset debug mode for each test
      mockConfig.isDebugMode = true;
    });

    test('Logger methods can be called without throwing', () {
      expect(() => Logger.d('Debug message'), returnsNormally);
      expect(() => Logger.i('Info message'), returnsNormally);
      expect(() => Logger.w('Warning message'), returnsNormally);
      expect(
        () => Logger.w('Warning with error', Exception('Test Error')),
        returnsNormally,
      );
      expect(() => Logger.e('Error message'), returnsNormally);
      expect(
        () => Logger.e(
          'Error with error',
          Exception('Test Error'),
          StackTrace.current,
        ),
        returnsNormally,
      );
    });

    test('Logger respects log level based on debug mode', () {
      // Set debug mode to false to change log level to info
      mockConfig.isDebugMode = false;

      // We can't easily assert print output, but we can check no exceptions are thrown
      expect(() => Logger.d('This should not be printed'), returnsNormally);
      expect(() => Logger.i('This should be printed'), returnsNormally);
    });
  });
}
