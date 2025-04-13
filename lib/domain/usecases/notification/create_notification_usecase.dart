import 'package:injectable/injectable.dart';
import '../../entities/notification_history_entity.dart';
import '../../repositories/notification_history_repository.dart';

/// 通知作成ユースケース
@injectable
class CreateNotificationUseCase {
  CreateNotificationUseCase(this._notificationHistoryRepository);

  final NotificationHistoryRepository _notificationHistoryRepository;

  /// 通知を作成し、履歴に保存する
  Future<NotificationHistoryEntity> execute({
    required String timerId,
    required String characterId,
    required String message,
    required DateTime notificationTime,
  }) async {
    final notification = NotificationHistoryEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // 簡易的なID生成
      timerId: timerId,
      characterId: characterId,
      message: message,
      notificationTime: notificationTime,
      createdAt: DateTime.now(),
    );

    await _notificationHistoryRepository.saveNotificationHistory(notification);
    return notification;
  }
}
