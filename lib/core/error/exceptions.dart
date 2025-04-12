/// Base class for all application-specific exceptions.
class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AppException(this.message, [this.stackTrace]);

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

// Add other specific exception types as needed.
