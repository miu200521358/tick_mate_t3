import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate/domain/entities/timer_entity.dart';
import 'package:tick_mate/domain/usecases/timer/create_timer_usecase.dart';
import 'package:tick_mate/domain/usecases/timer/get_timers_usecase.dart';
import 'package:tick_mate/presentation/bloc/common/bloc_error_handler.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_event.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_state.dart';

/// タイマー状態を管理するBLoC
class TimerBloc extends Bloc<TimerEvent, TimerState> {
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

  final GetTimersUseCase _getTimersUseCase;
  final CreateTimerUseCase _createTimerUseCase;

  /// タイマー読み込みイベントの処理
  Future<void> _onTimersLoaded(
    TimersLoaded event,
    Emitter<TimerState> emit,
  ) async {
    emit(const TimerLoading());
    await BlocErrorHandler.handle<List<TimerEntity>, TimerBloc, TimerState>(
      bloc: this,
      emit: emit,
      errorStateBuilder: (message) => TimerError(message: message),
      function: () async => _getTimersUseCase.execute(),
      context: event.context,
      messageKey: 'errorLoadingTimers',
    ).then((timers) {
      if (timers != null) {
        emit(TimerLoaded(timers: timers));
      }
    });
  }

  /// タイマー作成イベントの処理
  Future<void> _onTimerCreated(
    TimerCreated event,
    Emitter<TimerState> emit,
  ) async {
    emit(const TimerLoading());
    await BlocErrorHandler.handle<TimerEntity, TimerBloc, TimerState>(
      bloc: this,
      emit: emit,
      errorStateBuilder: (message) => TimerError(message: message),
      function:
          () async => _createTimerUseCase.execute(
            title: event.title,
            dateTime: event.dateTime,
            timeRange: event.timeRange,
            timerType: event.timerType,
            repeatType: event.repeatType,
            characterIds: event.characterIds,
            notificationSound: event.notificationSound,
            location: event.location,
            useCurrentLocation: event.useCurrentLocation,
          ),
      context: event.context,
      messageKey: 'errorCreatingTimer',
    ).then((timer) {
      if (timer != null) {
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
      }
    });
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
