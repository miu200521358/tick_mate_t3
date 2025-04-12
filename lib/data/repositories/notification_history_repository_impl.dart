import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/data/datasources/local/local_storage_datasource.dart';
import 'package:tick_mate_t3/data/models/notification_history_model.dart';
import 'package:tick_mate_t3/domain/entities/notification_history_entity.dart';
import 'package:tick_mate_t3/domain/repositories/notification_history_repository.dart';

/// 通知履歴リポジトリの実装
@LazySingleton(as: NotificationHistoryRepository)
class NotificationHistoryRepositoryImpl
    implements NotificationHistoryRepository {
  NotificationHistoryRepositoryImpl(this._localStorageDataSource);

  final LocalStorageDataSource _localStorageDataSource;

  @override
  Future<List<NotificationHistoryEntity>> getAllNotificationHistory() async {
    final historyModels = _localStorageDataSource.getAllNotificationHistory();
    return historyModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<NotificationHistoryEntity>> getNotificationHistoryByTimerId(
    String timerId,
  ) async {
    final historyModels = _localStorageDataSource
        .getNotificationHistoryByTimerId(timerId);
    return historyModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<NotificationHistoryEntity>> getNotificationHistoryByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final historyModels = _localStorageDataSource
        .getNotificationHistoryByDateRange(start, end);
    return historyModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveNotificationHistory(
    NotificationHistoryEntity notificationHistory,
  ) async {
    final historyModel = NotificationHistoryModel.fromEntity(
      notificationHistory,
    );
    await _localStorageDataSource.saveNotificationHistory(historyModel);
  }

  @override
  Future<void> deleteNotificationHistoryOlderThan(DateTime date) async {
    await _localStorageDataSource.deleteNotificationHistoryOlderThan(date);
  }

  @override
  Future<String> exportNotificationHistoryToCsv() async {
    final historyModels = _localStorageDataSource.getAllNotificationHistory();
    final entities = historyModels.map((model) => model.toEntity()).toList();

    // CSVヘッダー
    final csvData = [
      ['ID', '通知日時', 'タイマーID', 'キャラクターID', 'メッセージ', '作成日時'],
    ];

    // データ行の追加
    for (final entity in entities) {
      csvData.add([
        entity.id,
        entity.notificationTime.toIso8601String(),
        entity.timerId,
        entity.characterId,
        entity.message,
        entity.createdAt.toIso8601String(),
      ]);
    }

    // CSV形式に変換
    final csv = csvData.map((row) => row.join(',')).join('\n');
    return csv;
  }
}
