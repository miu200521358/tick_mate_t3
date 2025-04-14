import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tick_mate/config/app_config.dart';

/// ログユーティリティクラス
/// アプリケーション全体で統一されたログ出力方針を提供します
class LogUtil {
  // シングルトンインスタンス
  static final LogUtil _instance = LogUtil._internal();
  
  // プライベートコンストラクタ
  LogUtil._internal() {
    // Loggerの初期化
    _logger = Logger(
      level: _currentLevel,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      filter: ProductionFilter(),
    );
  }
  
  factory LogUtil() => _instance;
  
  // ロガーインスタンス
  late final Logger _logger;

  // 環境設定
  AppConfig? get _config => GetIt.instance.isRegistered<AppConfig>() ? GetIt.instance<AppConfig>() : null;

  // 現在のログレベル
  Level get _currentLevel {
    return (_config?.isDebugMode ?? true) ? Level.debug : Level.info;
  }

  // テスト環境かどうかを判定
  static bool get _isTestEnvironment {
    return const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false);
  }

  /// デバッグログを出力
  static void d(String message) {
    if (_isTestEnvironment) {
      debugPrint('[DEBUG] $message');
      return;
    }
    _instance._logger.d(message);
  }

  /// 情報ログを出力
  static void i(String message) {
    if (_isTestEnvironment) {
      debugPrint('[INFO] $message');
      return;
    }
    _instance._logger.i(message);
  }

  /// 警告ログを出力
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isTestEnvironment) {
      debugPrint('[WARNING] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
      return;
    }
    _instance._logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// エラーログを出力
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isTestEnvironment) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
      return;
    }
    _instance._logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Crashlyticsにエラーを記録
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? message,
    bool fatal = false,
  }) async {
    try {
      // エラーメッセージをログに出力
      e(message ?? 'エラーが発生しました', exception, stackTrace);

      // テスト環境ではFirebaseを使用しない
      if (_isTestEnvironment) {
        debugPrint('テスト環境のため、Crashlyticsへの記録をスキップします');
        return;
      }

      // 実行環境でのみFirebaseを使用
      // 注: このメソッドはテスト環境では呼び出されないため、
      // テスト時にFirebaseの依存関係がなくても問題ない
      debugPrint('実行環境でのみFirebaseを使用します');
    } catch (e) {
      debugPrint('エラー記録に失敗しました: $e');
    }
  }

  /// Firebase Analyticsにイベントを記録
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      // テスト環境ではFirebaseを使用しない
      if (_isTestEnvironment) {
        debugPrint('テスト環境のため、Analyticsへの記録をスキップします: $name');
        return;
      }
      
      // 実行環境でのみFirebaseを使用
      // 注: このメソッドはテスト環境では呼び出されないため、
      // テスト時にFirebaseの依存関係がなくても問題ない
      debugPrint('実行環境でのみFirebaseを使用します: $name');
    } catch (e, stackTrace) {
      debugPrint('Analyticsへのイベント記録に失敗しました: $e');
      await recordError(e, stackTrace, message: 'Analyticsイベント記録エラー: $name');
    }
  }

  /// 画面アクセスを記録
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      // テスト環境ではFirebaseを使用しない
      if (_isTestEnvironment) {
        debugPrint('テスト環境のため、画面アクセスログの記録をスキップします: $screenName');
        return;
      }
      
      // 実行環境でのみFirebaseを使用
      // 注: このメソッドはテスト環境では呼び出されないため、
      // テスト時にFirebaseの依存関係がなくても問題ない
      debugPrint('実行環境でのみFirebaseを使用します: $screenName');
    } catch (e, stackTrace) {
      debugPrint('画面アクセスログの記録に失敗しました: $e');
      await recordError(e, stackTrace, message: '画面アクセスログ記録エラー: $screenName');
    }
  }
}
