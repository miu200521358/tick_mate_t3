import 'package:flutter/material.dart'; // For TimeOfDay
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
    required TimeSpecificationType timeSpecificationType, // <<< 追加
    DateTime? dateTime,
    TimeOfDay? startTimeOfDay, // <<< 追加
    TimeOfDay? endTimeOfDay, // <<< 追加
    String? timeRange, // Keep for now, review later
    required TimerType timerType,
    required RepeatType repeatType,
    required List<String> characterIds,
    String? notificationSound,
    String? location,
    bool useCurrentLocation = false,
  }) async {
    // <<< Update validation based on timeSpecificationType >>>
    switch (timeSpecificationType) {
      case TimeSpecificationType.dateTime:
        if (dateTime == null) {
          throw ArgumentError(
            'dateTime is required for timeSpecificationType.dateTime',
          );
        }
        break;
      case TimeSpecificationType.specificTime:
        if (startTimeOfDay == null) {
          throw ArgumentError(
            'startTimeOfDay is required for timeSpecificationType.specificTime',
          );
        }
        break;
      case TimeSpecificationType.timeRange:
        if (startTimeOfDay == null || endTimeOfDay == null) {
          throw ArgumentError(
            'startTimeOfDay and endTimeOfDay are required for timeSpecificationType.timeRange',
          );
        }
        // Optional: Add validation for start time being before end time
        // if (startTimeOfDay.hour > endTimeOfDay.hour || (startTimeOfDay.hour == endTimeOfDay.hour && startTimeOfDay.minute >= endTimeOfDay.minute)) {
        //   throw ArgumentError('Start time must be before end time for time range');
        // }
        break;
    }

    // キャラクターIDが少なくとも1つ必要
    if (characterIds.isEmpty) {
      throw ArgumentError('少なくとも1つのキャラクターIDが必要です'); // TODO: Localize
    }

    final now = DateTime.now();
    final timer = TimerEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // 簡易的なID生成
      title: title,
      // <<< Pass new fields to entity >>>
      timeSpecificationType: timeSpecificationType,
      dateTime: dateTime,
      startTimeOfDay: startTimeOfDay,
      endTimeOfDay: endTimeOfDay,
      timeRange: timeRange, // Keep for now
      timerType: timerType,
      repeatType: repeatType,
      characterIds: characterIds,
      notificationSound: notificationSound,
      location: location,
      useCurrentLocation: useCurrentLocation,
      createdAt: now,
      updatedAt: now,
    );

    // Use the repository to save the timer
    await _timerRepository.saveTimer(timer);
    return timer;
  }
}
