import 'package:equatable/equatable.dart';
import 'package:tick_mate/domain/entities/timer_entity.dart';

/// タイマーBLoCの状態基底クラス
abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object?> get props => [];
}

/// タイマー初期状態
class TimerInitial extends TimerState {
  const TimerInitial();
}

/// タイマー読み込み中状態
class TimerLoading extends TimerState {
  const TimerLoading();
}

/// タイマー読み込み完了状態
class TimerLoaded extends TimerState {
  const TimerLoaded({required this.timers});

  final List<TimerEntity> timers;

  /// 新しい状態を作成
  TimerLoaded copyWith({List<TimerEntity>? timers}) {
    return TimerLoaded(timers: timers ?? this.timers);
  }

  @override
  List<Object?> get props => [timers];
}

/// タイマーエラー状態
class TimerError extends TimerState {
  const TimerError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
