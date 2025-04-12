import 'package:equatable/equatable.dart';
import 'package:tick_mate_t3/domain/entities/timer_entity.dart';

/// タイマーBLoCのイベント基底クラス
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

/// タイマー読み込みイベント
class TimersLoaded extends TimerEvent {
  const TimersLoaded();
}

/// タイマー作成イベント
class TimerCreated extends TimerEvent {
  final String title;
  final DateTime? dateTime;
  final String? timeRange;
  final TimerType timerType;
  final RepeatType repeatType;
  final List<String> characterIds;
  final String? notificationSound;
  final String? location;
  final bool useCurrentLocation;

  const TimerCreated({
    required this.title,
    this.dateTime,
    this.timeRange,
    required this.timerType,
    required this.repeatType,
    required this.characterIds,
    this.notificationSound,
    this.location,
    this.useCurrentLocation = false,
  });

  @override
  List<Object?> get props => [
    title,
    dateTime,
    timeRange,
    timerType,
    repeatType,
    characterIds,
    notificationSound,
    location,
    useCurrentLocation,
  ];
}

/// タイマー削除イベント
class TimerDeleted extends TimerEvent {
  final String id;

  const TimerDeleted({required this.id});

  @override
  List<Object?> get props => [id];
}
