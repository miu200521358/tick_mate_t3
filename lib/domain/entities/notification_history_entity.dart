import 'package:equatable/equatable.dart';

/// 通知履歴エンティティ
class NotificationHistoryEntity extends Equatable {
  const NotificationHistoryEntity({
    required this.id,
    required this.timerId,
    required this.characterId,
    required this.message,
    required this.notificationTime,
    required this.createdAt,
  });

  final String id;
  final String timerId;
  final String characterId;
  final String message;
  final DateTime notificationTime;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    timerId,
    characterId,
    message,
    notificationTime,
    createdAt,
  ];

  /// 新しい通知履歴エンティティを作成
  NotificationHistoryEntity copyWith({
    String? id,
    String? timerId,
    String? characterId,
    String? message,
    DateTime? notificationTime,
    DateTime? createdAt,
  }) {
    return NotificationHistoryEntity(
      id: id ?? this.id,
      timerId: timerId ?? this.timerId,
      characterId: characterId ?? this.characterId,
      message: message ?? this.message,
      notificationTime: notificationTime ?? this.notificationTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
