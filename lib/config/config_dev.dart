import 'package:injectable/injectable.dart';
import 'package:tick_mate/config/app_config.dart';

@Named('dev')
@LazySingleton(as: AppConfig)
class DevConfig implements AppConfig {
  @override
  String get baseUrl => 'https://dev.api.tickmate.example.com';

  @override
  bool get isDebugMode => true;

  @override
  bool get showBetaBanner => true;

  @override
  String get apiVersion => 'v1';

  // 画像関連の設定
  @override
  int get maxImageSizeKB => 2048; // 開発環境では大きめの値を許容

  @override
  int get maxImageWidth => 1920;

  @override
  int get maxImageHeight => 1080;

  // タイマー関連の設定
  @override
  int get defaultTimerDurationMinutes => 25;

  @override
  int get maxTimerDurationHours => 24;

  // UI関連の設定
  @override
  double get cardBorderRadius => 12.0;

  @override
  double get defaultPadding => 16.0;

  // アニメーション関連の設定
  @override
  Duration get defaultAnimationDuration => const Duration(milliseconds: 300);

  // APIレート制限関連の設定
  @override
  int get apiRateLimitPerMinute => 100; // 開発環境では緩めの制限

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
