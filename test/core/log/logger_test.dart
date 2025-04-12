import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate_t3/core/log/logger.dart';

void main() {
  group('Logger', () {
    // Note: Testing print statements directly is tricky.
    // These tests mainly check if the methods can be called without errors.
    // A more robust test would involve mocking print or using a dedicated logging package.

    setUp(() {
      // Reset log level before each test if needed
      Logger.currentLevel = LogLevel.debug;
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

    test('Logger respects log level', () {
      Logger.currentLevel = LogLevel.info;
      // We can't easily assert print output, but we can check no exceptions are thrown
      expect(() => Logger.d('This should not be printed'), returnsNormally);
      expect(() => Logger.i('This should be printed'), returnsNormally);
    });
  });
}
