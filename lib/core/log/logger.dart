import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/core/constants/app_constants.dart';

// シンプルなロガー。本番環境では専用のロギングパッケージの使用を検討してください。
enum LogLevel { debug, info, warning, error }

class Logger {
  static LogLevel get currentLevel {
    final config = GetIt.instance<AppConfig>();
    return config.isDebugMode ? LogLevel.debug : LogLevel.info;
  }

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

  /// Crashlyticsにエラーを記録する
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? message,
    bool fatal = false,
  }) async {
    try {
      // エラーメッセージをログに出力
      e(message ?? 'エラーが発生しました', exception, stackTrace);

      // Crashlyticsにエラーを記録
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stackTrace,
        reason: message,
        fatal: fatal,
        information: [if (message != null) message],
        printDetails: true,
      );

      // カスタムキーを設定
      await FirebaseCrashlytics.instance.setCustomKey(
        AppConstants.CRASHLYTICS_KEY_EXCEPTION_TYPE,
        exception.runtimeType.toString(),
      );

      if (message != null) {
        await FirebaseCrashlytics.instance.setCustomKey(
          AppConstants.CRASHLYTICS_KEY_MESSAGE,
          message,
        );
      }
    } catch (e) {
      debugPrint('Crashlyticsへのエラー記録に失敗しました: $e');
    }
  }
}
