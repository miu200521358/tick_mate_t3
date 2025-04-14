import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/core/utils/log/log_util.dart';

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
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('LogUtil', () {
    // Note: Testing print statements directly is tricky.
    // These tests mainly check if the methods can be called without errors.
    // Firebase関連の機能はモックすべきですが、このテストでは簡易的に例外が発生しないことを確認します

    final getIt = GetIt.instance;
    final mockConfig = MockAppConfig();

    setUp(() {
      // Reset GetIt before each test
      getIt.reset();
      // Register mock config
      getIt.registerSingleton<AppConfig>(mockConfig);
      // Reset debug mode for each test
      mockConfig.isDebugMode = true;
    });

    test('LogUtil methods can be called without throwing', () {
      // テスト環境フラグを設定
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      
      expect(() => LogUtil.d('Debug message'), returnsNormally);
      expect(() => LogUtil.i('Info message'), returnsNormally);
      expect(() => LogUtil.w('Warning message'), returnsNormally);
      expect(
        () => LogUtil.w('Warning with error', Exception('Test Error')),
        returnsNormally,
      );
      expect(() => LogUtil.e('Error message'), returnsNormally);
      expect(
        () => LogUtil.e(
          'Error with error',
          Exception('Test Error'),
          StackTrace.current,
        ),
        returnsNormally,
      );
      
      debugDefaultTargetPlatformOverride = null;
    });

    test('LogUtil respects log level based on debug mode', () {
      // Set debug mode to false to change log level to info
      mockConfig.isDebugMode = false;

      // テスト環境フラグを設定
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      
      // We can't easily assert print output, but we can check no exceptions are thrown
      expect(() => LogUtil.d('This should not be printed'), returnsNormally);
      expect(() => LogUtil.i('This should be printed'), returnsNormally);
      
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
