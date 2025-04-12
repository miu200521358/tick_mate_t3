import 'package:hive/hive.dart';
import 'package:tick_mate_t3/domain/entities/timer_entity.dart';

part 'timer_model.g.dart';

/// タイマーモデル（Hive用）
@HiveType(typeId: 1)
class TimerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime? dateTime;

  @HiveField(3)
  final String? timeRange;

  @HiveField(4)
  final int timerType;

  @HiveField(5)
  final int repeatType;

  @HiveField(6)
  final List<String> characterIds;

  @HiveField(7)
  final String? notificationSound;

  @HiveField(8)
  final String? location;

  @HiveField(9)
  final bool useCurrentLocation;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  TimerModel({
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

  /// エンティティからモデルに変換
  factory TimerModel.fromEntity(TimerEntity entity) {
    return TimerModel(
      id: entity.id,
      title: entity.title,
      dateTime: entity.dateTime,
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

  /// モデルからエンティティに変換
  TimerEntity toEntity() {
    return TimerEntity(
      id: id,
      title: title,
      dateTime: dateTime,
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
