import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/config/config_dev.dart';
import 'package:tick_mate/config/config_prod.dart';
import 'package:tick_mate/config/config_stg.dart';
// Note: We cannot directly import main.dart as it calls runApp.
// We need to extract or make _setupConfig accessible.
// For now, let's redefine a similar function for testing.

// Helper function mimicking the logic in main.dart's _setupConfig
void setupTestConfig(String environment) {
  final getIt = GetIt.instance;
  // Ensure clean state for each test
  getIt.reset();

  late AppConfig config;
  switch (environment) {
    case 'prod':
      config = ProdConfig();
      break;
    case 'stg':
      config = StgConfig();
      break;
    case 'dev':
    default:
      config = DevConfig();
      break;
  }
  getIt.registerSingleton<AppConfig>(config);
}

void main() {
  group('AppConfig Initialization', () {
    test('should register DevConfig for "dev" environment', () {
      setupTestConfig('dev');
      final config = GetIt.instance<AppConfig>();
      expect(config, isA<DevConfig>());
      expect(config.baseUrl, 'https://dev.api.tickmate.example.com');
      expect(config.isDebugMode, true);
      expect(config.showBetaBanner, true);
    });

    test('should register DevConfig for default (unknown) environment', () {
      setupTestConfig('unknown');
      final config = GetIt.instance<AppConfig>();
      expect(config, isA<DevConfig>());
      expect(config.baseUrl, 'https://dev.api.tickmate.example.com');
      expect(config.isDebugMode, true);
      expect(config.showBetaBanner, true);
    });

    test('should register StgConfig for "stg" environment', () {
      setupTestConfig('stg');
      final config = GetIt.instance<AppConfig>();
      expect(config, isA<StgConfig>());
      expect(config.baseUrl, 'https://stg.api.tickmate.example.com');
      expect(config.isDebugMode, false);
      expect(config.showBetaBanner, true);
    });

    test('should register ProdConfig for "prod" environment', () {
      setupTestConfig('prod');
      final config = GetIt.instance<AppConfig>();
      expect(config, isA<ProdConfig>());
      expect(config.baseUrl, 'https://api.tickmate.example.com');
      expect(config.isDebugMode, false);
      expect(config.showBetaBanner, false);
    });

    // Clean up GetIt after tests if necessary, though reset() handles it per test
    tearDown(() {
      GetIt.instance.reset();
    });
  });
}
