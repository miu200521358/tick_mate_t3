import '../entities/notification_history_entity.dart';

/// 通知履歴リポジトリインターフェース
abstract class NotificationHistoryRepository {
  /// すべての通知履歴を取得
  Future<List<NotificationHistoryEntity>> getAllNotificationHistory();

  /// タイマーIDで通知履歴を取得
  Future<List<NotificationHistoryEntity>> getNotificationHistoryByTimerId(
    String timerId,
  );

  /// 日付範囲で通知履歴を取得
  Future<List<NotificationHistoryEntity>> getNotificationHistoryByDateRange(
    DateTime start,
    DateTime end,
  );

  /// 通知履歴を保存
  Future<void> saveNotificationHistory(
    NotificationHistoryEntity notificationHistory,
  );

  /// 通知履歴を一括削除（期間指定）
  Future<void> deleteNotificationHistoryOlderThan(DateTime date);

  /// 通知履歴をCSVでエクスポート
  Future<String> exportNotificationHistoryToCsv();
}
