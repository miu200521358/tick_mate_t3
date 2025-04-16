import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // For TimeOfDay

/// タイマー種別
enum TimerType {
  /// 予定通知
  schedule,

  /// 近況報告
  status,
}

/// 繰り返し種別
enum RepeatType {
  /// 繰り返しなし
  none,

  /// 毎日
  daily,

  /// 平日（月～金）
  weekdays,

  /// 毎週
  weekly,

  /// 隔週
  biweekly,

  /// 毎月第○曜日
  monthlyByWeekday,

  /// 隔月第○曜日
  bimonthlyByWeekday,

  /// 毎月○日
  monthlyByDay,

  /// 隔月○日
  bimonthlyByDay,

  /// 毎年○月○日
  yearly,

  /// 一定日数おき
  customDays,
}

/// 時間指定種別
enum TimeSpecificationType {
  /// 日時を指定
  dateTime,

  /// 特定時刻のみを指定
  specificTime,

  /// 特定時間範囲を指定
  timeRange,
}

/// タイマーエンティティ
class TimerEntity extends Equatable {
  const TimerEntity({
    required this.id,
    required this.title,
    required this.timeSpecificationType, // <<< 追加
    this.dateTime, // Used when timeSpecificationType is dateTime
    this.startTimeOfDay, // Used when timeSpecificationType is specificTime or timeRange (TimeOfDay?)
    this.endTimeOfDay, // Used when timeSpecificationType is timeRange (TimeOfDay?)
    this.timeRange, // TODO: Review if this is still needed or replaced by startTimeOfDay/endTimeOfDay
    required this.timerType,
    required this.repeatType,
    this.repeatDetails = const {}, // 繰り返しパターンの詳細情報
    required this.characterIds,
    this.notificationSound,
    this.location,
    this.useCurrentLocation = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final TimeSpecificationType timeSpecificationType;
  final DateTime? dateTime;
  final TimeOfDay? startTimeOfDay;
  final TimeOfDay? endTimeOfDay;
  final String? timeRange; // Keep for now, review later if needed
  final TimerType timerType;
  final RepeatType repeatType;
  final List<String> characterIds;
  final String? notificationSound;
  final String? location;
  final bool useCurrentLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// タイマーが有効かどうかをチェック
  bool get isValid {
    // TODO: Update validation logic based on timeSpecificationType
    switch (timeSpecificationType) {
      case TimeSpecificationType.dateTime:
        return dateTime != null;
      case TimeSpecificationType.specificTime:
        return startTimeOfDay != null;
      case TimeSpecificationType.timeRange:
        // Ensure start is before end? Or just that both exist? For now, just existence.
        return startTimeOfDay != null && endTimeOfDay != null;
      // Default case should not happen if type is always set
    }
    // return dateTime != null || timeRange != null; // Old logic
  }

  @override
  List<Object?> get props => [
    id,
    title,
    timeSpecificationType, // <<< 追加
    dateTime,
    startTimeOfDay, // <<< 追加
    endTimeOfDay, // <<< 追加
    timeRange,
    timerType,
    repeatType,
    repeatDetails,
    characterIds,
    notificationSound,
    location,
    useCurrentLocation,
    createdAt,
    updatedAt,
  ];

  /// 新しいタイマーエンティティを作成
  TimerEntity copyWith({
    String? id,
    String? title,
    TimeSpecificationType? timeSpecificationType, // <<< 追加
    // Use ValueGetter to allow explicitly setting to null
    ValueGetter<DateTime?>? dateTime,
    ValueGetter<TimeOfDay?>? startTimeOfDay, // <<< 追加
    ValueGetter<TimeOfDay?>? endTimeOfDay, // <<< 追加
    ValueGetter<String?>? timeRange,
    TimerType? timerType,
    RepeatType? repeatType,
    Map<String, dynamic>? repeatDetails,
    List<String>? characterIds,
    String? notificationSound,
    String? location,
    bool? useCurrentLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TimerEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      timeSpecificationType:
          timeSpecificationType ?? this.timeSpecificationType, // <<< 追加
      dateTime: dateTime != null ? dateTime() : this.dateTime,
      startTimeOfDay:
          startTimeOfDay != null
              ? startTimeOfDay()
              : this.startTimeOfDay, // <<< 追加
      endTimeOfDay:
          endTimeOfDay != null ? endTimeOfDay() : this.endTimeOfDay, // <<< 追加
      timeRange: timeRange != null ? timeRange() : this.timeRange,
      timerType: timerType ?? this.timerType,
      repeatType: repeatType ?? this.repeatType,
      repeatDetails: repeatDetails ?? this.repeatDetails,
      characterIds: characterIds ?? this.characterIds,
      notificationSound: notificationSound ?? this.notificationSound,
      location: location ?? this.location,
      useCurrentLocation: useCurrentLocation ?? this.useCurrentLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
