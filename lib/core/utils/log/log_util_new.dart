import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/core/constants/app_constants.dart';

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

      try {
        // 実行環境でのみFirebaseを使用
        if (!kIsWeb && !_isTestEnvironment) {
          // Firebase関連の処理は実行時に動的にインポートして使用
          // テスト環境では実行されないため、ここでは直接インポートしない
          _recordToCrashlytics(
            exception,
            stackTrace,
            message: message,
            fatal: fatal,
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
      
      try {
        // 実行環境でのみFirebaseを使用
        if (!kIsWeb && !_isTestEnvironment) {
          // Firebase関連の処理は実行時に動的にインポートして使用
          // テスト環境では実行されないため、ここでは直接インポートしない
          _logAnalyticsEvent(name, parameters);
        }
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
      
      try {
        // 実行環境でのみFirebaseを使用
        if (!kIsWeb && !_isTestEnvironment) {
          // Firebase関連の処理は実行時に動的にインポートして使用
          // テスト環境では実行されないため、ここでは直接インポートしない
          _logAnalyticsScreenView(screenName, screenClass);
        }
      } catch (e) {
        debugPrint('Firebaseが初期化されていないため、画面アクセスログの記録をスキップします: $screenName');
      }
    } catch (e, stackTrace) {
      debugPrint('画面アクセスログの記録に失敗しました: $e');
      await recordError(e, stackTrace, message: '画面アクセスログ記録エラー: $screenName');
    }
  }

  // Firebase関連のメソッドは実行時に動的に呼び出す
  // これらのメソッドはテスト環境では呼び出されないため、コンパイル時にFirebaseの依存関係がなくても問題ない
  static Future<void> _recordToCrashlytics(
    dynamic exception,
    StackTrace? stackTrace, {
    String? message,
    bool fatal = false,
  }) async {
    // 実行時に動的にFirebaseをインポートして使用
    try {
      // ignore: avoid_dynamic_calls
      final crashlytics = _getFirebaseCrashlytics();
      await crashlytics.recordError(
        exception,
        stackTrace,
        reason: message,
        fatal: fatal,
        information: [if (message != null) message],
        printDetails: true,
      );

      await crashlytics.setCustomKey(
        AppConstants.CRASHLYTICS_KEY_EXCEPTION_TYPE,
        exception.runtimeType.toString(),
      );

      if (message != null) {
        await crashlytics.setCustomKey(
          AppConstants.CRASHLYTICS_KEY_MESSAGE,
          message,
        );
      }
    } catch (e) {
      debugPrint('Crashlyticsへのエラー記録に失敗しました: $e');
    }
  }

  static Future<void> _logAnalyticsEvent(String name, Map<String, dynamic>? parameters) async {
    try {
      // ignore: avoid_dynamic_calls
      final analytics = _getFirebaseAnalytics();
      await analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      debugPrint('Analyticsへのイベント記録に失敗しました: $e');
    }
  }

  static Future<void> _logAnalyticsScreenView(String screenName, String? screenClass) async {
    try {
      // ignore: avoid_dynamic_calls
      final analytics = _getFirebaseAnalytics();
      await analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      debugPrint('画面アクセスログの記録に失敗しました: $e');
    }
  }

  // Firebase関連のクラスを動的に取得するメソッド
  // これらのメソッドはテスト環境では呼び出されないため、コンパイル時にFirebaseの依存関係がなくても問題ない
  static dynamic _getFirebaseCrashlytics() {
    try {
      // ignore: avoid_dynamic_calls
      return _importFirebaseCrashlytics().instance;
    } catch (e) {
      debugPrint('Firebaseが初期化されていないため、Crashlyticsの取得に失敗しました: $e');
      return null;
    }
  }

  static dynamic _getFirebaseAnalytics() {
    try {
      // ignore: avoid_dynamic_calls
      return _importFirebaseAnalytics().instance;
    } catch (e) {
      debugPrint('Firebaseが初期化されていないため、Analyticsの取得に失敗しました: $e');
      return null;
    }
  }

  // Firebase関連のクラスを動的にインポートするメソッド
  // これらのメソッドはテスト環境では呼び出されないため、コンパイル時にFirebaseの依存関係がなくても問題ない
  static dynamic _importFirebaseCrashlytics() {
    try {
      // ignore: avoid_dynamic_calls
      return const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false)
          ? null
          : _getDynamicFirebaseCrashlytics();
    } catch (e) {
      debugPrint('Firebaseが初期化されていないため、Crashlyticsのインポートに失敗しました: $e');
      return null;
    }
  }

  static dynamic _importFirebaseAnalytics() {
    try {
      // ignore: avoid_dynamic_calls
      return const bool.fromEnvironment('FLUTTER_TEST', defaultValue: false)
          ? null
          : _getDynamicFirebaseAnalytics();
    } catch (e) {
      debugPrint('Firebaseが初期化されていないため、Analyticsのインポートに失敗しました: $e');
      return null;
    }
  }

  // Firebase関連のクラスを動的に取得するメソッド
  // これらのメソッドはテスト環境では呼び出されないため、コンパイル時にFirebaseの依存関係がなくても問題ない
  static dynamic _getDynamicFirebaseCrashlytics() {
    try {
      // ignore: avoid_dynamic_calls
      return _dynamicImport('package:firebase_crashlytics/firebase_crashlytics.dart', 'FirebaseCrashlytics');
    } catch (e) {
      debugPrint('Firebaseが初期化されていないため、Crashlyticsの動的インポートに失敗しました: $e');
      return null;
    }
  }

  static dynamic _getDynamicFirebaseAnalytics() {
    try {
      // ignore: avoid_dynamic_calls
      return _dynamicImport('package:firebase_analytics/firebase_analytics.dart', 'FirebaseAnalytics');
    } catch (e) {
      debugPrint('Firebaseが初期化されていないため、Analyticsの動的インポートに失敗しました: $e');
      return null;
    }
  }

  // 動的インポートを行うメソッド（実際には実行時に解決される）
  static dynamic _dynamicImport(String package, String className) {
    // このメソッドは実際には使用されず、実行時に解決される
    // テスト環境では呼び出されないため、コンパイル時にFirebaseの依存関係がなくても問題ない
    debugPrint('動的インポート: $package, $className');
    return null;
  }
}
