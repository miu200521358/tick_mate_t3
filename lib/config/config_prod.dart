import 'package:injectable/injectable.dart';
import 'package:tick_mate/config/app_config.dart';

@Named('prod')
@LazySingleton(as: AppConfig)
class ProdConfig implements AppConfig {
  @override
  String get baseUrl => 'https://api.tickmate.example.com';

  @override
  bool get isDebugMode => false;

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
  int get apiRateLimitPerMinute => 30; // 本番環境では厳しめの制限

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
