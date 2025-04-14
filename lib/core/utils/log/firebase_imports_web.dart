import 'package:flutter/foundation.dart';

// モックの Firebase Analytics クラス
class FirebaseAnalytics {
  static final FirebaseAnalytics _instance = FirebaseAnalytics._();
  static FirebaseAnalytics get instance => _instance;

  FirebaseAnalytics._();

  Future<void> logEvent({required String name, Map<String, dynamic>? parameters}) async {
    debugPrint('Firebase Analytics logEvent: $name, params: $parameters');
  }

  Future<void> logScreenView({required String screenName, String? screenClass}) async {
    debugPrint('Firebase Analytics logScreenView: $screenName, class: $screenClass');
  }
}

// テスト環境用の Firebase Analytics インスタンスを提供
FirebaseAnalytics getFirebaseAnalytics() {
  return FirebaseAnalytics.instance;
}

// テスト環境用の Crashlytics エラー記録
Future<void> recordToCrashlytics(
  dynamic exception,
  StackTrace? stackTrace, {
  String? reason,
  bool fatal = false,
  List<String> information = const [],
  bool printDetails = true,
}) async {
  debugPrint('Crashlytics recordError: $reason');
  if (exception != null) debugPrint('Exception: $exception');
  if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  if (information.isNotEmpty) debugPrint('Information: $information');
}

// テスト環境用の Crashlytics カスタムキー設定
Future<void> setCrashlyticsCustomKey(String key, String value) async {
  debugPrint('Crashlytics setCustomKey: $key = $value');
}
