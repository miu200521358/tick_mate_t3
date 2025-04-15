// ignore_for_file: constant_identifier_names

class AppConstants {
  static const String appName = 'Tick Mate T3';

  // 環境変数キー
  static const String ENV_KEY = 'ENV';
  static const String BASE_URL_KEY = 'BASE_URL';
  static const String API_VERSION_KEY = 'API_VERSION';
  static const String DEBUG_MODE_KEY = 'DEBUG_MODE';
  static const String SHOW_BETA_BANNER_KEY = 'SHOW_BETA_BANNER';
  // 以下追加
  static const String MAX_IMAGE_SIZE_KB_KEY = 'MAX_IMAGE_SIZE_KB';
  static const String MAX_IMAGE_WIDTH_KEY = 'MAX_IMAGE_WIDTH';
  static const String MAX_IMAGE_HEIGHT_KEY = 'MAX_IMAGE_HEIGHT';
  static const String DEFAULT_TIMER_DURATION_KEY = 'DEFAULT_TIMER_DURATION';
  static const String MAX_TIMER_DURATION_HOURS_KEY = 'MAX_TIMER_DURATION_HOURS';
  static const String API_RATE_LIMIT_KEY = 'API_RATE_LIMIT';

  // データベーススキーマバージョン
  static const int currentDbSchemaVersion = 1; // 初期バージョン

  // 通知関連
  static const String NOTIFICATION_CHANNEL_ID = 'tick_mate_notifications';
  static const String NOTIFICATION_CHANNEL_NAME = 'タイマー通知';
  static const String NOTIFICATION_CHANNEL_DESCRIPTION = 'TickMateのタイマー通知チャンネル';
  static const String NOTIFICATION_ICON = '@mipmap/ic_launcher';

  // Firebase Analytics イベント名
  static const String NOTIFICATION_EVENT = 'notification_sent';
  static const String PARAM_NOTIFICATION_TIME = 'notification_time';
  static const String PARAM_CHARACTER_NAME = 'character_name';
  static const String PARAM_MESSAGE = 'message';

  // Firebase Crashlytics関連
  static const String CRASHLYTICS_KEY_EXCEPTION_TYPE = 'exception_type';
  static const String CRASHLYTICS_KEY_MESSAGE = 'error_message';

  // エラーハンドリング関連
  static const int ERROR_SNACKBAR_DURATION_SECONDS = 4;
  static const String ERROR_DEFAULT_MESSAGE = 'エラーが発生しました。';

  // 言語コード
  static const String LANG_JA = 'ja';
  static const String LANG_EN = 'en';

  // APIキー関連
  static const String GEMINI_API_KEY = 'gemini_api_key';

  // コンテンツ制限関連
  static const int MIN_TITLE_LENGTH = 3;
  static const int MAX_TITLE_LENGTH = 50;
  static const int MIN_DESCRIPTION_LENGTH = 0;
  static const int MAX_DESCRIPTION_LENGTH = 500;

  // ページネーション関連
  static const int DEFAULT_PAGE_SIZE = 20;
  static const int MAX_PAGE_SIZE = 100;

  // キャッシュ関連
  static const Duration DEFAULT_CACHE_DURATION = Duration(hours: 24);

  // タイマー関連
  static const int DEFAULT_NOTIFICATION_MINUTES_BEFORE = 5;
  static const int MAX_ACTIVE_TIMERS = 20;

  // 画像キャッシュ関連
  static const String IMAGE_CACHE_DIRECTORY = 'image_cache';
  static const int IMAGE_CACHE_SIZE_MB = 100;
}
