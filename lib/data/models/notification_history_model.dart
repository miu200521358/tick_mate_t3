import 'package:hive/hive.dart';
import 'package:tick_mate_t3/domain/entities/notification_history_entity.dart';

part 'notification_history_model.g.dart';

/// 通知履歴モデル（Hive用）
@HiveType(typeId: 4)
class NotificationHistoryModel extends HiveObject {
  NotificationHistoryModel({
    required this.id,
    required this.timerId,
    required this.characterId,
    required this.message,
    required this.notificationTime,
    required this.createdAt,
  });

  /// エンティティからモデルに変換
  factory NotificationHistoryModel.fromEntity(
    NotificationHistoryEntity entity,
  ) {
    return NotificationHistoryModel(
      id: entity.id,
      timerId: entity.timerId,
      characterId: entity.characterId,
      message: entity.message,
      notificationTime: entity.notificationTime,
      createdAt: entity.createdAt,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String timerId;

  @HiveField(2)
  final String characterId;

  @HiveField(3)
  final String message;

  @HiveField(4)
  final DateTime notificationTime;

  @HiveField(5)
  final DateTime createdAt;

  /// モデルからエンティティに変換
  NotificationHistoryEntity toEntity() {
    return NotificationHistoryEntity(
      id: id,
      timerId: timerId,
      characterId: characterId,
      message: message,
      notificationTime: notificationTime,
      createdAt: createdAt,
    );
  }
}
