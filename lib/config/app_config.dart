abstract class AppConfig {
  String get baseUrl;
  bool get isDebugMode;
  bool get showBetaBanner;
  String get apiVersion;

  // 画像関連の設定
  int get maxImageSizeKB;
  int get maxImageWidth;
  int get maxImageHeight;

  // タイマー関連の設定
  int get defaultTimerDurationMinutes;
  int get maxTimerDurationHours;

  // UI関連の設定
  double get cardBorderRadius;
  double get defaultPadding;

  // アニメーション関連の設定
  Duration get defaultAnimationDuration;

  // APIレート制限関連の設定
  int get apiRateLimitPerMinute;

  // HTTP通信関連の設定
  Duration get defaultConnectTimeout;
  Duration get defaultReceiveTimeout;
  Duration get defaultSendTimeout;
  
  // Gemini API用のタイムアウト設定
  Duration get geminiConnectTimeout;
  Duration get geminiReceiveTimeout;
  Duration get geminiSendTimeout;

  // その他の環境依存設定があれば追加
}
