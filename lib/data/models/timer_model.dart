import 'package:flutter/material.dart'; // For TimeOfDay
import 'package:hive/hive.dart';
import 'package:tick_mate/domain/entities/timer_entity.dart';

part 'timer_model.g.dart';

/// タイマーモデル（Hive用）
@HiveType(typeId: 1)
class TimerModel extends HiveObject {
  TimerModel({
    required this.id,
    required this.title,
    required this.timeSpecificationType, // <<< 追加
    this.dateTime,
    this.startTimeOfDayHour, // <<< 追加
    this.startTimeOfDayMinute, // <<< 追加
    this.endTimeOfDayHour, // <<< 追加
    this.endTimeOfDayMinute, // <<< 追加
    this.timeRange,
    required this.timerType,
    required this.repeatType,
    required this.characterIds,
    this.notificationSound,
    this.location,
    this.useCurrentLocation = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// エンティティからモデルに変換
  factory TimerModel.fromEntity(TimerEntity entity) {
    return TimerModel(
      id: entity.id,
      title: entity.title,
      timeSpecificationType: entity.timeSpecificationType.index, // <<< 追加
      dateTime: entity.dateTime,
      startTimeOfDayHour: entity.startTimeOfDay?.hour, // <<< 追加
      startTimeOfDayMinute: entity.startTimeOfDay?.minute, // <<< 追加
      endTimeOfDayHour: entity.endTimeOfDay?.hour, // <<< 追加
      endTimeOfDayMinute: entity.endTimeOfDay?.minute, // <<< 追加
      timeRange: entity.timeRange,
      timerType: entity.timerType.index,
      repeatType: entity.repeatType.index,
      characterIds: entity.characterIds,
      notificationSound: entity.notificationSound,
      location: entity.location,
      useCurrentLocation: entity.useCurrentLocation,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  // <<< 新しいフィールドを追加 >>>
  @HiveField(2)
  final int timeSpecificationType;

  @HiveField(3)
  final DateTime? dateTime;

  @HiveField(4)
  final int? startTimeOfDayHour;

  @HiveField(5)
  final int? startTimeOfDayMinute;

  @HiveField(6)
  final int? endTimeOfDayHour;

  @HiveField(7)
  final int? endTimeOfDayMinute;

  // <<< 既存フィールドのインデックスを更新 >>>
  @HiveField(8)
  final String? timeRange;

  @HiveField(9)
  final int timerType;

  @HiveField(10)
  final int repeatType;

  @HiveField(11)
  final List<String> characterIds;

  @HiveField(12)
  final String? notificationSound;

  @HiveField(13)
  final String? location;

  @HiveField(14)
  final bool useCurrentLocation;

  @HiveField(15)
  final DateTime createdAt;

  @HiveField(16)
  final DateTime updatedAt;

  /// モデルからエンティティに変換
  TimerEntity toEntity() {
    TimeOfDay? startTime;
    if (startTimeOfDayHour != null && startTimeOfDayMinute != null) {
      startTime = TimeOfDay(
        hour: startTimeOfDayHour!,
        minute: startTimeOfDayMinute!,
      );
    }
    TimeOfDay? endTime;
    if (endTimeOfDayHour != null && endTimeOfDayMinute != null) {
      endTime = TimeOfDay(hour: endTimeOfDayHour!, minute: endTimeOfDayMinute!);
    }

    return TimerEntity(
      id: id,
      title: title,
      timeSpecificationType:
          TimeSpecificationType.values[timeSpecificationType], // <<< 追加
      dateTime: dateTime,
      startTimeOfDay: startTime, // <<< 追加
      endTimeOfDay: endTime, // <<< 追加
      timeRange: timeRange,
      timerType: TimerType.values[timerType],
      repeatType: RepeatType.values[repeatType],
      characterIds: characterIds,
      notificationSound: notificationSound,
      location: location,
      useCurrentLocation: useCurrentLocation,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
