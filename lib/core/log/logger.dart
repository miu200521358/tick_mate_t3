import 'package:flutter/foundation.dart';

// シンプルなロガー。本番環境では専用のロギングパッケージの使用を検討してください。
enum LogLevel { debug, info, warning, error }

class Logger {
  static LogLevel currentLevel = LogLevel.debug; // または設定から読み込む

  static void log(
    LogLevel level,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    if (level.index >= currentLevel.index) {
      final timestamp = DateTime.now();
      // debugPrintはリリースビルドでは何もしないため、開発中にのみログが出力される
      debugPrint('[$timestamp] [${level.name.toUpperCase()}] $message');
      if (error != null) {
        debugPrint('  Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('  StackTrace: $stackTrace');
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
