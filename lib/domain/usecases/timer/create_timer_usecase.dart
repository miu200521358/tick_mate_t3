import 'package:injectable/injectable.dart';
import '../../entities/timer_entity.dart';
import '../../repositories/timer_repository.dart';

/// タイマー作成ユースケース
@injectable
class CreateTimerUseCase {
  CreateTimerUseCase(this._timerRepository);

  final TimerRepository _timerRepository;

  /// タイマーを作成する
  Future<TimerEntity> execute({
    required String title,
    DateTime? dateTime,
    String? timeRange,
    required TimerType timerType,
    required RepeatType repeatType,
    required List<String> characterIds,
    String? notificationSound,
    String? location,
    bool useCurrentLocation = false,
  }) async {
    // 日時または時間範囲が必要
    if (dateTime == null && timeRange == null) {
      throw ArgumentError('dateTime または timeRange は必須です');
    }

    // キャラクターIDが少なくとも1つ必要
    if (characterIds.isEmpty) {
      throw ArgumentError('少なくとも1つのキャラクターIDが必要です');
    }

    final now = DateTime.now();
    final timer = TimerEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // 簡易的なID生成
      title: title,
      dateTime: dateTime,
      timeRange: timeRange,
      timerType: timerType,
      repeatType: repeatType,
      characterIds: characterIds,
      notificationSound: notificationSound,
      location: location,
      useCurrentLocation: useCurrentLocation,
      createdAt: now,
      updatedAt: now,
    );

    await _timerRepository.saveTimer(timer);
    return timer;
  }
}
