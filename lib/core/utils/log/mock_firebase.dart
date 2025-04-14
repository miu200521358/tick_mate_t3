import 'package:flutter/foundation.dart';

/// テスト環境用のモックFirebaseクラス
class MockFirebaseAnalytics {
  static final MockFirebaseAnalytics _instance = MockFirebaseAnalytics._();
  
  MockFirebaseAnalytics._();
  
  static MockFirebaseAnalytics get instance => _instance;

  Future<void> logEvent({required String name, Map<String, dynamic>? parameters}) async {
    debugPrint('[MOCK] Analytics logEvent: $name, params: $parameters');
  }

  Future<void> logScreenView({required String screenName, String? screenClass}) async {
    debugPrint('[MOCK] Analytics logScreenView: $screenName, class: $screenClass');
  }
}

class MockFirebaseCrashlytics {
  static final MockFirebaseCrashlytics _instance = MockFirebaseCrashlytics._();
  
  MockFirebaseCrashlytics._();
  
  static MockFirebaseCrashlytics get instance => _instance;

  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
    List<String>? information,
    bool printDetails = true,
  }) async {
    debugPrint('[MOCK] Crashlytics recordError: $reason');
    if (exception != null) debugPrint('[MOCK] Exception: $exception');
    if (stackTrace != null) debugPrint('[MOCK] StackTrace: $stackTrace');
    if (information != null && information.isNotEmpty) debugPrint('[MOCK] Information: $information');
  }

  Future<void> setCustomKey(String key, String value) async {
    debugPrint('[MOCK] Crashlytics setCustomKey: $key = $value');
  }
}
