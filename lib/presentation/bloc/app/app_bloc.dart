import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate/presentation/bloc/app/app_event.dart';
import 'package:tick_mate/presentation/bloc/app/app_state.dart';

/// アプリ全体の状態を管理するBLoC
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<ThemeChanged>(_onThemeChanged);
    on<LanguageChanged>(_onLanguageChanged);
  }

  void _onAppStarted(AppStarted event, Emitter<AppState> emit) {
    // アプリ起動時の初期化処理
    emit(const AppReady());
  }

  void _onThemeChanged(ThemeChanged event, Emitter<AppState> emit) {
    // テーマ変更処理
    if (state is AppReady) {
      final currentState = state as AppReady;
      emit(currentState.copyWith(isDarkMode: event.isDarkMode));
    }
  }

  void _onLanguageChanged(LanguageChanged event, Emitter<AppState> emit) {
    // 言語変更処理
    if (state is AppReady) {
      final currentState = state as AppReady;
      emit(currentState.copyWith(locale: event.locale));
    }
  }
}
