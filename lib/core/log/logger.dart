// Simple logger using print. Consider using a dedicated logging package for production.
enum LogLevel { debug, info, warning, error }

class Logger {
  static LogLevel currentLevel = LogLevel.debug; // Or load from config

  static void log(
    LogLevel level,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (level.index >= currentLevel.index) {
      final timestamp = DateTime.now();
      print('[$timestamp] [${level.name.toUpperCase()}] $message');
      if (error != null) {
        print('  Error: $error');
      }
      if (stackTrace != null) {
        print('  StackTrace: $stackTrace');
      }
    }
  }

  static void d(String message) => log(LogLevel.debug, message);
  static void i(String message) => log(LogLevel.info, message);
  static void w(String message, [dynamic error, StackTrace? stackTrace]) =>
      log(LogLevel.warning, message, error, stackTrace);
  static void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      log(LogLevel.error, message, error, stackTrace);
}
