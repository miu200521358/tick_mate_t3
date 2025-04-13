/// Hiveボックス名の定数
class HiveBoxes {
  // ボックス名
  static const String timerBox = 'timers';
  static const String characterBox = 'characters';
  static const String workBox = 'works';
  static const String notificationHistoryBox = 'notification_histories';
  static const String userSettingBox = 'user_settings';
  static const String subscriptionBox = 'subscriptions';
  static const String migrationInfoBox = 'migration_info'; // 追加

  // タイプID
  static const int timerTypeId = 1;
  static const int characterTypeId = 2;
  static const int workTypeId = 3;
  static const int notificationHistoryTypeId = 4;
  static const int userSettingTypeId = 6; // 順番注意
  static const int subscriptionTypeId = 5; // 順番注意
  static const int migrationInfoTypeId = 7; // 追加
}
