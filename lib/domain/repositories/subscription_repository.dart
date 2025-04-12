import '../entities/subscription_entity.dart';

/// サブスクリプションリポジトリインターフェース
abstract class SubscriptionRepository {
  /// 現在のサブスクリプション情報を取得
  Future<SubscriptionEntity?> getCurrentSubscription();

  /// ユーザーIDからサブスクリプション情報を取得
  Future<SubscriptionEntity?> getSubscriptionByUserId(String userId);

  /// サブスクリプション情報を保存
  Future<void> saveSubscription(SubscriptionEntity subscription);

  /// サブスクリプションプランを更新
  Future<void> updateSubscriptionPlan(
    String id,
    SubscriptionPlanType planType,
    int additionalTimerCount,
    DateTime? expiryDate,
  );

  /// サブスクリプション情報を削除
  Future<void> deleteSubscription(String id);
}
