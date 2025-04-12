import 'package:hive/hive.dart';
import 'package:tick_mate_t3/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate_t3/data/models/character_model.dart';
import 'package:tick_mate_t3/data/models/notification_history_model.dart';
import 'package:tick_mate_t3/data/models/timer_model.dart';
import 'package:tick_mate_t3/data/models/work_model.dart';

/// ローカルストレージデータソース
class LocalStorageDataSource {
  /// タイマーボックスを取得
  Box<TimerModel> getTimerBox() {
    return Hive.box<TimerModel>(HiveBoxes.timerBox);
  }

  /// キャラクターボックスを取得
  Box<CharacterModel> getCharacterBox() {
    return Hive.box<CharacterModel>(HiveBoxes.characterBox);
  }

  /// 作品ボックスを取得
  Box<WorkModel> getWorkBox() {
    return Hive.box<WorkModel>(HiveBoxes.workBox);
  }

  /// 通知履歴ボックスを取得
  Box<NotificationHistoryModel> getNotificationHistoryBox() {
    return Hive.box<NotificationHistoryModel>(HiveBoxes.notificationHistoryBox);
  }

  /// すべてのタイマーを取得
  List<TimerModel> getAllTimers() {
    final box = getTimerBox();
    return box.values.toList();
  }

  /// IDでタイマーを取得
  TimerModel? getTimerById(String id) {
    final box = getTimerBox();
    return box.get(id);
  }

  /// 特定の日時に発動するタイマーを取得
  List<TimerModel> getTimersByDateTime(DateTime dateTime) {
    final box = getTimerBox();
    return box.values.where((timer) {
      if (timer.dateTime == null) return false;

      final timerDate = DateTime(
        timer.dateTime!.year,
        timer.dateTime!.month,
        timer.dateTime!.day,
      );

      final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      return timerDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  /// タイマーを保存
  Future<void> saveTimer(TimerModel timer) async {
    final box = getTimerBox();
    await box.put(timer.id, timer);
  }

  /// タイマーを削除
  Future<void> deleteTimer(String id) async {
    final box = getTimerBox();
    await box.delete(id);
  }

  /// すべてのキャラクターを取得
  List<CharacterModel> getAllCharacters() {
    final box = getCharacterBox();
    return box.values.toList();
  }

  /// 作品IDでキャラクターを取得
  List<CharacterModel> getCharactersByWorkId(String workId) {
    final box = getCharacterBox();
    return box.values.where((character) => character.workId == workId).toList();
  }

  /// IDでキャラクターを取得
  CharacterModel? getCharacterById(String id) {
    final box = getCharacterBox();
    return box.get(id);
  }

  /// 複数のIDでキャラクターを取得
  List<CharacterModel> getCharactersByIds(List<String> ids) {
    final box = getCharacterBox();
    return box.values.where((character) => ids.contains(character.id)).toList();
  }

  /// キャラクターを保存
  Future<void> saveCharacter(CharacterModel character) async {
    final box = getCharacterBox();
    await box.put(character.id, character);
  }

  /// キャラクターを削除
  Future<void> deleteCharacter(String id) async {
    final box = getCharacterBox();
    await box.delete(id);
  }

  /// すべての作品を取得
  List<WorkModel> getAllWorks() {
    final box = getWorkBox();
    return box.values.toList();
  }

  /// IDで作品を取得
  WorkModel? getWorkById(String id) {
    final box = getWorkBox();
    return box.get(id);
  }

  /// 作品を保存
  Future<void> saveWork(WorkModel work) async {
    final box = getWorkBox();
    await box.put(work.id, work);
  }

  /// 作品を削除
  Future<void> deleteWork(String id) async {
    final box = getWorkBox();
    await box.delete(id);
  }

  /// すべての通知履歴を取得
  List<NotificationHistoryModel> getAllNotificationHistory() {
    final box = getNotificationHistoryBox();
    return box.values.toList();
  }

  /// タイマーIDで通知履歴を取得
  List<NotificationHistoryModel> getNotificationHistoryByTimerId(
    String timerId,
  ) {
    final box = getNotificationHistoryBox();
    return box.values.where((history) => history.timerId == timerId).toList();
  }

  /// 日付範囲で通知履歴を取得
  List<NotificationHistoryModel> getNotificationHistoryByDateRange(
    DateTime start,
    DateTime end,
  ) {
    final box = getNotificationHistoryBox();
    return box.values.where((history) {
      final notificationDate = history.notificationTime;
      return notificationDate.isAfter(start) && notificationDate.isBefore(end);
    }).toList();
  }

  /// 通知履歴を保存
  Future<void> saveNotificationHistory(
    NotificationHistoryModel notificationHistory,
  ) async {
    final box = getNotificationHistoryBox();
    await box.put(notificationHistory.id, notificationHistory);
  }

  /// 通知履歴を一括削除（期間指定）
  Future<void> deleteNotificationHistoryOlderThan(DateTime date) async {
    final box = getNotificationHistoryBox();
    final keysToDelete =
        box.values
            .where((history) => history.notificationTime.isBefore(date))
            .map((history) => history.id)
            .toList();

    for (final key in keysToDelete) {
      await box.delete(key);
    }
  }
}
