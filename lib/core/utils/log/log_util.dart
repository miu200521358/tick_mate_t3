import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/core/constants/app_constants.dart';

// Firebase関連のインポートは条件付きで行う
import 'firebase_imports.dart'
    if (dart.library.html) 'firebase_imports_web.dart';

/// ログユーティリティクラス
/// アプリケーション全体で統一されたログ出力方針を提供します
class LogUtil {
  factory LogUtil() => _instance;

  // プライベートコンストラクタ
  LogUtil._internal()
    : _analytics = _isTestEnvironment ? null : getFirebaseAnalytics() {
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

  // テスト用コンストラクタ
  @visibleForTesting
  LogUtil.test() : _analytics = null {
    _logger = Logger(
      level: Level.debug,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  // テスト用コンストラクタ（内部使用）
  LogUtil._test(this._logger) : _analytics = null;

  /// テスト環境用に LogUtil を初期化する
  /// このメソッドはテストコード内でのみ使用してください
  @visibleForTesting
  static void initializeForTest() {
    // テスト環境フラグを強制的に true に設定
    _forceTestEnvironment = true;
  }

  // シングルトンインスタンスを安全に取得
  static LogUtil get _safeInstance {
    if (_isTestEnvironment) {
      // テスト環境では新しいインスタンスを作成して返す
      return LogUtil._createTestInstance();
    }
    return _instance;
  }

  // シングルトンインスタンス
  static final LogUtil _instance = LogUtil._internal();

  // テスト環境用のインスタンスを作成
  static LogUtil _createTestInstance() {
    final logger = Logger(
      level: Level.debug,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );

    return LogUtil._test(logger);
  }

  // ロガーインスタンス
  late final Logger _logger;

  // Firebase Analyticsインスタンス
  final dynamic _analytics;

  // 環境設定
  AppConfig? get _config =>
      GetIt.instance.isRegistered<AppConfig>()
          ? GetIt.instance<AppConfig>()
          : null;

  // 現在のログレベル
  Level get _currentLevel {
    return (_config?.isDebugMode ?? true) ? Level.debug : Level.info;
  }

  // テスト用の環境フラグ
  static bool _forceTestEnvironment = false;

  // テスト環境かどうかを判定
  static bool get _isTestEnvironment {
    return _forceTestEnvironment ||
        (kDebugMode &&
            const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false));
  }

  /// デバッグログを出力
  static void d(String message) {
    if (_isTestEnvironment) {
      debugPrint('[DEBUG] $message');
      return;
    }
    _safeInstance._logger.d(message);
  }

  /// 情報ログを出力
  static void i(String message) {
    if (_isTestEnvironment) {
      debugPrint('[INFO] $message');
      return;
    }
    _safeInstance._logger.i(message);
  }

  /// 警告ログを出力
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isTestEnvironment) {
      debugPrint('[WARNING] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
      return;
    }
    _safeInstance._logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// エラーログを出力
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (_isTestEnvironment) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
      return;
    }
    _safeInstance._logger.e(message, error: error, stackTrace: stackTrace);
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

      try {
        // Crashlyticsにエラーを記録
        await recordToCrashlytics(
          exception,
          stackTrace,
          reason: message,
          fatal: fatal,
          information: [if (message != null) message],
          printDetails: true,
        );

        // カスタムキーを設定
        await setCrashlyticsCustomKey(
          AppConstants.CRASHLYTICS_KEY_EXCEPTION_TYPE,
          exception.runtimeType.toString(),
        );

        if (message != null) {
          await setCrashlyticsCustomKey(
            AppConstants.CRASHLYTICS_KEY_MESSAGE,
            message,
          );
        }
      } catch (e) {
        debugPrint('Firebaseが初期化されていないため、Crashlyticsへの記録をスキップします');
      }
    } catch (e) {
      debugPrint('Crashlyticsへのエラー記録に失敗しました: $e');
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

      final analytics = _instance._analytics;
      if (analytics == null) {
        debugPrint('Analyticsが初期化されていないため、イベント記録をスキップします: $name');
        return;
      }

      try {
        await analytics.logEvent(name: name, parameters: parameters);
      } catch (e) {
        debugPrint('Firebaseが初期化されていないため、Analyticsへの記録をスキップします: $name');
      }
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

      final analytics = _instance._analytics;
      if (analytics == null) {
        debugPrint('Analyticsが初期化されていないため、画面アクセスログの記録をスキップします: $screenName');
        return;
      }

      try {
        await analytics.logScreenView(
          screenName: screenName,
          screenClass: screenClass,
        );
      } catch (e) {
        debugPrint('Firebaseが初期化されていないため、画面アクセスログの記録をスキップします: $screenName');
      }
    } catch (e, stackTrace) {
      debugPrint('画面アクセスログの記録に失敗しました: $e');
      await recordError(e, stackTrace, message: '画面アクセスログ記録エラー: $screenName');
    }
  }
}
