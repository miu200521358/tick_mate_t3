import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate_t3/domain/entities/timer_entity.dart';
import 'package:tick_mate_t3/domain/usecases/timer/create_timer_usecase.dart';
import 'package:tick_mate_t3/domain/usecases/timer/get_timers_usecase.dart';
import 'package:tick_mate_t3/presentation/bloc/timer/timer_event.dart';
import 'package:tick_mate_t3/presentation/bloc/timer/timer_state.dart';

/// タイマー状態を管理するBLoC
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final GetTimersUseCase _getTimersUseCase;
  final CreateTimerUseCase _createTimerUseCase;

  TimerBloc({
    required GetTimersUseCase getTimersUseCase,
    required CreateTimerUseCase createTimerUseCase,
  }) : _getTimersUseCase = getTimersUseCase,
       _createTimerUseCase = createTimerUseCase,
       super(const TimerInitial()) {
    on<TimersLoaded>(_onTimersLoaded);
    on<TimerCreated>(_onTimerCreated);
    on<TimerDeleted>(_onTimerDeleted);
  }

  /// タイマー読み込みイベントの処理
  Future<void> _onTimersLoaded(
    TimersLoaded event,
    Emitter<TimerState> emit,
  ) async {
    emit(const TimerLoading());
    try {
      final timers = await _getTimersUseCase.execute();
      emit(TimerLoaded(timers: timers));
    } catch (e) {
      emit(TimerError(message: e.toString()));
    }
  }

  /// タイマー作成イベントの処理
  Future<void> _onTimerCreated(
    TimerCreated event,
    Emitter<TimerState> emit,
  ) async {
    emit(const TimerLoading());
    try {
      final timer = await _createTimerUseCase.execute(
        title: event.title,
        dateTime: event.dateTime,
        timeRange: event.timeRange,
        timerType: event.timerType,
        repeatType: event.repeatType,
        characterIds: event.characterIds,
        notificationSound: event.notificationSound,
        location: event.location,
        useCurrentLocation: event.useCurrentLocation,
      );

      // 現在の状態がTimerLoadedの場合、新しいタイマーを追加
      if (state is TimerLoaded) {
        final currentState = state as TimerLoaded;
        final updatedTimers = List<TimerEntity>.from(currentState.timers)
          ..add(timer);
        emit(currentState.copyWith(timers: updatedTimers));
      } else {
        // それ以外の場合は、1つのタイマーだけを含む新しいリストを作成
        emit(TimerLoaded(timers: [timer]));
      }
    } catch (e) {
      emit(TimerError(message: e.toString()));
    }
  }

  /// タイマー削除イベントの処理
  Future<void> _onTimerDeleted(
    TimerDeleted event,
    Emitter<TimerState> emit,
  ) async {
    // 実装は後のIssueで追加
    // TODO: タイマー削除機能の実装
  }
}
