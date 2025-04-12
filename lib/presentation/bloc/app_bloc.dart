import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// イベント
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

/// アプリの初期化イベント
class AppInitialized extends AppEvent {}

/// 画面遷移イベント
class NavigateToScreen extends AppEvent {
  final int screenIndex;

  const NavigateToScreen(this.screenIndex);

  @override
  List<Object> get props => [screenIndex];
}

// 状態
abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

/// 初期化中の状態
class AppInitializing extends AppState {}

/// 初期化完了状態
class AppInitialized extends AppState {
  final int currentScreenIndex;

  const AppInitialized({this.currentScreenIndex = 0});

  @override
  List<Object> get props => [currentScreenIndex];

  AppInitialized copyWith({int? currentScreenIndex}) {
    return AppInitialized(
      currentScreenIndex: currentScreenIndex ?? this.currentScreenIndex,
    );
  }
}

/// アプリBLoC
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitializing()) {
    on<AppInitialized>(_onAppInitialized);
    on<NavigateToScreen>(_onNavigateToScreen);
  }

  void _onAppInitialized(AppInitialized event, Emitter<AppState> emit) {
    emit(const AppInitialized());
  }

  void _onNavigateToScreen(NavigateToScreen event, Emitter<AppState> emit) {
    final currentState = state;
    if (currentState is AppInitialized) {
      emit(currentState.copyWith(currentScreenIndex: event.screenIndex));
    }
  }
}
