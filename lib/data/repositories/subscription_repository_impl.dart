import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate/data/models/subscription_model.dart';
import 'package:tick_mate/domain/entities/subscription_entity.dart';
import 'package:tick_mate/domain/repositories/subscription_repository.dart';

@LazySingleton(as: SubscriptionRepository)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl()
    : _subscriptionBox = Hive.box<SubscriptionModel>(HiveBoxes.subscriptionBox);

  final Box<SubscriptionModel> _subscriptionBox;

  @override
  Future<SubscriptionEntity?> getCurrentSubscription() async {
    if (_subscriptionBox.isEmpty) {
      return null;
    }
    return _subscriptionBox.values.first.toEntity();
  }

  @override
  Future<SubscriptionEntity?> getSubscriptionByUserId(String userId) async {
    final subscriptions =
        _subscriptionBox.values
            .where((subscription) => subscription.userId == userId)
            .toList();

    if (subscriptions.isEmpty) {
      return null;
    }
    return subscriptions.first.toEntity();
  }

  @override
  Future<void> saveSubscription(SubscriptionEntity subscription) async {
    final model = SubscriptionModel.fromEntity(subscription);
    await _subscriptionBox.put(model.id, model);
  }

  @override
  Future<void> updateSubscriptionPlan(
    String id,
    SubscriptionPlanType planType,
    int additionalTimerCount,
    DateTime? expiryDate,
  ) async {
    final subscription = _subscriptionBox.get(id);
    if (subscription == null) {
      return;
    }

    final updatedSubscription = SubscriptionModel(
      id: subscription.id,
      planType: planType.index,
      additionalTimerCount: additionalTimerCount,
      expiryDate: expiryDate,
      userId: subscription.userId,
      createdAt: subscription.createdAt,
      updatedAt: DateTime.now(),
    );

    await _subscriptionBox.put(id, updatedSubscription);
  }

  @override
  Future<void> deleteSubscription(String id) async {
    await _subscriptionBox.delete(id);
  }
}
