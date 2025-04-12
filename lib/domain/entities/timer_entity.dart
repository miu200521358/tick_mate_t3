import 'package:equatable/equatable.dart';

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

  /// 一定日数おき
  customDays,
}

/// タイマーエンティティ
class TimerEntity extends Equatable {
  final String id;
  final String title;
  final DateTime? dateTime;
  final String? timeRange;
  final TimerType timerType;
  final RepeatType repeatType;
  final List<String> characterIds;
  final String? notificationSound;
  final String? location;
  final bool useCurrentLocation;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TimerEntity({
    required this.id,
    required this.title,
    this.dateTime,
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

  /// タイマーが有効かどうかをチェック
  bool get isValid {
    // 日時の設定またはタイムレンジが必要
    return dateTime != null || timeRange != null;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    dateTime,
    timeRange,
    timerType,
    repeatType,
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
    DateTime? dateTime,
    String? timeRange,
    TimerType? timerType,
    RepeatType? repeatType,
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
      dateTime: dateTime ?? this.dateTime,
      timeRange: timeRange ?? this.timeRange,
      timerType: timerType ?? this.timerType,
      repeatType: repeatType ?? this.repeatType,
      characterIds: characterIds ?? this.characterIds,
      notificationSound: notificationSound ?? this.notificationSound,
      location: location ?? this.location,
      useCurrentLocation: useCurrentLocation ?? this.useCurrentLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
