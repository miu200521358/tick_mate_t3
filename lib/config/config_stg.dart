import 'package:injectable/injectable.dart';
import 'package:tick_mate/config/app_config.dart';

@Named('stg')
@LazySingleton(as: AppConfig)
class StgConfig implements AppConfig {
  @override
  String get baseUrl => 'https://stg.api.tickmate.example.com';

  @override
  bool get isDebugMode => false;

  @override
  bool get showBetaBanner => true;

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
  Duration get defaultAnimationDuration => const Duration(milliseconds: 250);

  // APIレート制限関連の設定
  @override
  int get apiRateLimitPerMinute => 60;
}
