import '../entities/timer_entity.dart';

/// タイマーリポジトリインターフェース
abstract class TimerRepository {
  /// すべてのタイマーを取得
  Future<List<TimerEntity>> getAllTimers();

  /// IDでタイマーを取得
  Future<TimerEntity?> getTimerById(String id);

  /// 特定の日時に発動するタイマーを取得
  Future<List<TimerEntity>> getTimersByDateTime(DateTime dateTime);

  /// タイマーを保存
  Future<void> saveTimer(TimerEntity timer);

  /// タイマーを削除
  Future<void> deleteTimer(String id);
}
