import 'package:hive/hive.dart';
import 'package:tick_mate/domain/entities/subscription_entity.dart';

part 'subscription_model.g.dart';

/// サブスクリプションモデル（Hive用）
@HiveType(typeId: 5)
class SubscriptionModel extends HiveObject {
  SubscriptionModel({
    required this.id,
    required this.planType,
    required this.additionalTimerCount,
    this.expiryDate,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// エンティティからモデルに変換
  factory SubscriptionModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionModel(
      id: entity.id,
      planType: entity.planType.index,
      additionalTimerCount: entity.additionalTimerCount,
      expiryDate: entity.expiryDate,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int planType;

  @HiveField(2)
  final int additionalTimerCount;

  @HiveField(3)
  final DateTime? expiryDate;

  @HiveField(4)
  final String userId;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  /// モデルからエンティティに変換
  SubscriptionEntity toEntity() {
    return SubscriptionEntity(
      id: id,
      planType: SubscriptionPlanType.values[planType],
      additionalTimerCount: additionalTimerCount,
      expiryDate: expiryDate,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
