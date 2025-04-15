import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// 実際の Firebase インスタンスを提供
FirebaseAnalytics getFirebaseAnalytics() {
  return FirebaseAnalytics.instance;
}

// Crashlytics へのエラー記録
Future<void> recordToCrashlytics(
  dynamic exception,
  StackTrace? stackTrace, {
  String? reason,
  bool fatal = false,
  List<String> information = const [],
  bool printDetails = true,
}) async {
  await FirebaseCrashlytics.instance.recordError(
    exception,
    stackTrace,
    reason: reason,
    fatal: fatal,
    information: information,
    printDetails: printDetails,
  );
}

// Crashlytics にカスタムキーを設定
Future<void> setCrashlyticsCustomKey(String key, String value) async {
  await FirebaseCrashlytics.instance.setCustomKey(key, value);
}
