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
            // <<< Pass new fields to use case >>>
            timeSpecificationType: event.timeSpecificationType,
            dateTime: event.dateTime,
            startTimeOfDay: event.startTimeOfDay,
            endTimeOfDay: event.endTimeOfDay,
            timeRange: event.timeRange, // Keep for now, review later
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
        // Emit success state to trigger navigation or other UI updates
        emit(const TimerCreateSuccess());

        // Update the list of timers if the current state is TimerLoaded
        final currentStateSnapshot = state; // Capture state after success emit
        if (currentStateSnapshot is TimerLoaded) {
          final updatedTimers = List<TimerEntity>.from(
            currentStateSnapshot.timers,
          )..add(timer);
          // Emit updated loaded state *after* the success state
          emit(currentStateSnapshot.copyWith(timers: updatedTimers));
        } else {
          // If the state wasn't TimerLoaded, load the single new timer.
          // This might happen if creation is the first action.
          emit(TimerLoaded(timers: [timer]));
        }
      }
      // Errors are handled by BlocErrorHandler, which emits TimerError
    });
  }

  /// タイマー削除イベントの処理
  Future<void> _onTimerDeleted(
    TimerDeleted event,
    Emitter<TimerState> emit,
  ) async {
    // 現在の状態がTimerLoadedの場合のみ処理を実行
    if (state is TimerLoaded) {
      final currentState = state as TimerLoaded;
      emit(const TimerLoading());

      // 実際の削除処理は後のIssueで実装するため、ここではエラーハンドリングの例として実装
      await BlocErrorHandler.handle<bool, TimerBloc, TimerState>(
        bloc: this,
        emit: emit,
        errorStateBuilder: (message) => TimerError(message: message),
        function: () async {
          // 実際の削除処理は後のIssueで実装
          // 現時点では成功したと仮定して、タイマーリストから該当IDのタイマーを除外
          final updatedTimers =
              currentState.timers
                  .where((timer) => timer.id != event.id)
                  .toList();

          // 更新されたタイマーリストで状態を更新
          emit(TimerLoaded(timers: updatedTimers));
          return true;
        },
        context: event.context,
        messageKey: 'errorDeletingTimer',
      );
    }
  }
}
