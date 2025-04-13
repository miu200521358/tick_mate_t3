/// Base class for all application-specific exceptions.
class AppException implements Exception {
  const AppException(this.message, [this.stackTrace]);

  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'AppException: $message';
}

/// Exception for server-related errors (e.g., API failures).
class ServerException extends AppException {
  const ServerException(super.message, [super.stackTrace]);
}

/// Exception for local cache-related errors (e.g., Hive errors).
class CacheException extends AppException {
  const CacheException(super.message, [super.stackTrace]);
}

/// Exception for input validation errors.
class ValidationException extends AppException {
  const ValidationException(super.message, [super.stackTrace]);
}

/// 通信タイムアウト例外
class TimeoutException extends ServerException {
  const TimeoutException(super.message, [super.stackTrace]);
}

/// ネットワーク接続エラー例外
class NetworkException extends ServerException {
  const NetworkException(super.message, [super.stackTrace]);
}

/// API認証エラー例外
class AuthenticationException extends ServerException {
  const AuthenticationException(super.message, [super.stackTrace]);
}

// Add other specific exception types as needed.
