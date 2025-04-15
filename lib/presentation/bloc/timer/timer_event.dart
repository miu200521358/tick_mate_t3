import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tick_mate/domain/entities/timer_entity.dart';

/// タイマーBLoCのイベント基底クラス
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

/// タイマー読み込みイベント
class TimersLoaded extends TimerEvent {
  const TimersLoaded({this.context});

  final BuildContext? context;

  @override
  List<Object?> get props => [context];
}

/// タイマー作成イベント
class TimerCreated extends TimerEvent {
  const TimerCreated({
    required this.title,
    required this.timeSpecificationType, // <<< 追加
    this.dateTime,
    this.startTimeOfDay, // <<< 追加
    this.endTimeOfDay, // <<< 追加
    this.timeRange,
    required this.timerType,
    required this.repeatType,
    required this.characterIds,
    this.notificationSound,
    this.location,
    this.useCurrentLocation = false,
    this.context,
  });

  final String title;
  final TimeSpecificationType timeSpecificationType; // <<< 追加
  final DateTime? dateTime;
  final TimeOfDay? startTimeOfDay; // <<< 追加
  final TimeOfDay? endTimeOfDay; // <<< 追加
  final String? timeRange;
  final TimerType timerType;
  final RepeatType repeatType;
  final List<String> characterIds;
  final String? notificationSound;
  final String? location;
  final bool useCurrentLocation;
  final BuildContext? context;

  @override
  List<Object?> get props => [
    title,
    timeSpecificationType, // <<< 追加
    dateTime,
    startTimeOfDay, // <<< 追加
    endTimeOfDay, // <<< 追加
    timeRange,
    timerType,
    repeatType,
    characterIds,
    notificationSound,
    location,
    useCurrentLocation,
    context,
  ];
}

/// タイマー削除イベント
class TimerDeleted extends TimerEvent {
  const TimerDeleted({required this.id, this.context});

  final String id;
  final BuildContext? context;

  @override
  List<Object?> get props => [id, context];
}
