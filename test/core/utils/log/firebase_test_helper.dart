import 'package:tick_mate/core/utils/log/log_util.dart';

/// LogUtilのテスト用ヘルパークラス
class LogTestHelper {
  /// テスト環境用にLogUtilを初期化します
  ///
  /// このメソッドはテスト実行前に呼び出すことで、
  /// Firebaseの初期化エラーを回避します
  static void initializeForTest() {
    LogUtil.initializeForTest();
  }
}
