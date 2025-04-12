import 'package:equatable/equatable.dart';

/// サブスクリプションプラン種別
enum SubscriptionPlanType {
  /// 無料プラン
  free,

  /// 有料プラン
  premium,
}

/// サブスクリプションエンティティ
class SubscriptionEntity extends Equatable {
  const SubscriptionEntity({
    required this.id,
    required this.planType,
    required this.additionalTimerCount,
    this.expiryDate,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final SubscriptionPlanType planType;
  final int additionalTimerCount;
  final DateTime? expiryDate;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    planType,
    additionalTimerCount,
    expiryDate,
    userId,
    createdAt,
    updatedAt,
  ];

  /// 有効期限が切れているかどうか
  bool get isExpired {
    if (planType == SubscriptionPlanType.free) {
      return false; // 無料プランは有効期限なし
    }
    return expiryDate != null && DateTime.now().isAfter(expiryDate!);
  }

  /// サブスクリプションが有効かどうか
  bool get isValid {
    return !isExpired;
  }

  /// 新しいサブスクリプションエンティティを作成
  SubscriptionEntity copyWith({
    String? id,
    SubscriptionPlanType? planType,
    int? additionalTimerCount,
    DateTime? expiryDate,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      planType: planType ?? this.planType,
      additionalTimerCount: additionalTimerCount ?? this.additionalTimerCount,
      expiryDate: expiryDate ?? this.expiryDate,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
