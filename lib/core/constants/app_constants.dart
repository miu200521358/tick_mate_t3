// ignore_for_file: constant_identifier_names

class AppConstants {
  static const String appName = 'Tick Mate T3';

  // 環境変数キー
  static const String ENV_KEY = 'ENV';
  static const String BASE_URL_KEY = 'BASE_URL';
  static const String API_VERSION_KEY = 'API_VERSION';
  static const String DEBUG_MODE_KEY = 'DEBUG_MODE';
  static const String SHOW_BETA_BANNER_KEY = 'SHOW_BETA_BANNER';
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
}
