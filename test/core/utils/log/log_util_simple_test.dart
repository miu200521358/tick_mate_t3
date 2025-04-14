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
  
  group('LogUtil Simple Tests', () {
    final getIt = GetIt.instance;
    final mockConfig = MockAppConfig();

    setUp(() {
      // Reset GetIt before each test
      getIt.reset();
      // Register mock config
      getIt.registerSingleton<AppConfig>(mockConfig);
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
