import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/core/utils/log/log_util.dart';
import 'firebase_test_helper.dart';

// AppConfigのモック
class MockAppConfig implements AppConfig {
  @override
  String get baseUrl => 'https://mock.api.example.com';

  @override
  bool isDebugMode = true;

  @override
  bool get showBetaBanner => false;

  @override
  String get apiVersion => 'v1';

  // 画像関連の設定
  @override
  int get maxImageSizeKB => 1024;

  @override
  int get maxImageWidth => 1280;

  @override
  int get maxImageHeight => 720;

  // タイマー関連の設定
  @override
  int get defaultTimerDurationMinutes => 25;

  @override
  int get maxTimerDurationHours => 12;

  // UI関連の設定
  @override
  double get cardBorderRadius => 12.0;

  @override
  double get defaultPadding => 16.0;

  // アニメーション関連の設定
  @override
  Duration get defaultAnimationDuration => const Duration(milliseconds: 200);

  // APIレート制限関連の設定
  @override
  int get apiRateLimitPerMinute => 30;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LogUtil Basic Tests', () {
    // Note: Testing print statements directly is tricky.
    // These tests mainly check if the basic logging methods can be called without errors.
    // Firebase関連の機能はテストしません

    final getIt = GetIt.instance;
    final mockConfig = MockAppConfig();

    setUp(() {
      // Reset GetIt before each test
      getIt.reset();
      // Register mock config
      getIt.registerSingleton<AppConfig>(mockConfig);
      // Reset debug mode for each test
      mockConfig.isDebugMode = true;
      // LogUtilをテスト環境用に初期化
      LogTestHelper.initializeForTest();
    });

    test('LogUtil basic logging methods can be called without throwing', () {
      // Only test the basic logging methods that don't interact with Firebase
      expect(() => LogUtil.d('Debug message'), returnsNormally);
      expect(() => LogUtil.i('Info message'), returnsNormally);
      expect(() => LogUtil.w('Warning message'), returnsNormally);
      expect(() => LogUtil.e('Error message'), returnsNormally);
    });

    test('LogUtil respects log level based on debug mode', () {
      // Set debug mode to false to change log level to info
      mockConfig.isDebugMode = false;

      // We can't easily assert print output, but we can check no exceptions are thrown
      expect(() => LogUtil.d('This should not be printed'), returnsNormally);
      expect(() => LogUtil.i('This should be printed'), returnsNormally);
    });
  });
}
