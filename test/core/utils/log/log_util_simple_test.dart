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

  // HTTP通信関連の設定
  @override
  Duration get defaultConnectTimeout => const Duration(seconds: 10);

  @override
  Duration get defaultReceiveTimeout => const Duration(seconds: 10);

  @override
  Duration get defaultSendTimeout => const Duration(seconds: 10);

  // Gemini API用のタイムアウト設定
  @override
  Duration get geminiConnectTimeout => const Duration(seconds: 5);

  @override
  Duration get geminiReceiveTimeout => const Duration(seconds: 5);

  @override
  Duration get geminiSendTimeout => const Duration(seconds: 5);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LogUtil Simple Tests', () {
    final getIt = GetIt.instance;
    final mockConfig = MockAppConfig();

    setUp(() {
      // Reset GetIt before each test
      getIt.reset();
      // Register mock config
      getIt.registerSingleton<AppConfig>(mockConfig);
      // LogUtilをテスト環境用に初期化
      LogTestHelper.initializeForTest();
    });

    test('LogUtil can be used in tests', () {
      // Just verify that we can use the static methods without throwing
      LogUtil.d('Test debug message');
      LogUtil.i('Test info message');
      LogUtil.w('Test warning message');
      LogUtil.e('Test error message');

      // If we get here without exceptions, the test passes
      expect(true, isTrue);
    });
  });
}
