import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate/core/error/exceptions.dart';

void main() {
  group('AppException', () {
    test('AppException stores message and optional stacktrace', () {
      const message = 'Test Exception';
      final stackTrace = StackTrace.current;
      final exception = AppException(message, stackTrace);

      expect(exception.message, message);
      expect(exception.stackTrace, stackTrace);
      expect(exception.toString(), 'AppException: $message');
    });

    test('AppException works without stacktrace', () {
      const message = 'Test Exception No Stack';
      const exception = AppException(message);

      expect(exception.message, message);
      expect(exception.stackTrace, isNull);
      expect(exception.toString(), 'AppException: $message');
    });
  });

  group('Specific Exceptions', () {
    test('ServerException inherits from AppException', () {
      const exception = ServerException('Server Error');
      expect(exception, isA<AppException>());
      expect(exception.message, 'Server Error');
    });

    test('CacheException inherits from AppException', () {
      const exception = CacheException('Cache Error');
      expect(exception, isA<AppException>());
      expect(exception.message, 'Cache Error');
    });

    test('ValidationException inherits from AppException', () {
      const exception = ValidationException('Validation Error');
      expect(exception, isA<AppException>());
      expect(exception.message, 'Validation Error');
    });
  });
}
