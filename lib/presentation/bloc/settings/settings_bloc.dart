import 'package:flutter_bloc/flutter_bloc.dart';
// No injectable needed
import 'package:tick_mate_t3/data/datasources/local/secure_storage_datasource.dart';
import 'package:tick_mate_t3/data/datasources/remote/gemini_api_datasource.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_event.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_state.dart';

/// 設定画面のBLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._secureStorage, this._geminiApiDataSource)
    : super(const SettingsInitial()) {
    on<SettingsInitialized>(_onSettingsInitialized);
    on<GeminiApiKeySaved>(_onGeminiApiKeySaved);
    on<GeminiApiKeyDeleted>(_onGeminiApiKeyDeleted);
    on<GeminiApiKeyTested>(_onGeminiApiKeyTested);
  }

  final SecureStorageDataSource _secureStorage;
  final GeminiApiDataSource _geminiApiDataSource;

  /// 設定画面初期化時のハンドラ
  Future<void> _onSettingsInitialized(
    SettingsInitialized event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      final apiKey = await _secureStorage.getGeminiApiKey();
      emit(SettingsLoaded(geminiApiKey: apiKey));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  /// Gemini APIキー保存時のハンドラ
  Future<void> _onGeminiApiKeySaved(
    GeminiApiKeySaved event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      await _secureStorage.saveGeminiApiKey(event.apiKey);
      final apiKey = await _secureStorage.getGeminiApiKey();
      emit(SettingsLoaded(geminiApiKey: apiKey));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  /// Gemini APIキー削除時のハンドラ
  Future<void> _onGeminiApiKeyDeleted(
    GeminiApiKeyDeleted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      await _secureStorage.deleteGeminiApiKey();
      emit(const SettingsLoaded(geminiApiKey: null));
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  /// Gemini APIキーテスト時のハンドラ
  Future<void> _onGeminiApiKeyTested(
    GeminiApiKeyTested event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      // テスト中状態にする
      emit(currentState.copyWith(isTesting: true));

      try {
        // テスト用に一時的にAPIキーを保存
        await _secureStorage.saveGeminiApiKey(event.apiKey);

        // 簡単なリクエストを送信してAPIキーをテスト
        const testPrompt = 'Hello, can you respond with "API key is valid"?';
        final response = await _geminiApiDataSource.generateMessage(
          prompt: testPrompt,
          maxTokens: 10,
        );

        // テスト結果を設定
        emit(
          currentState.copyWith(
            geminiApiKey: event.apiKey,
            isTesting: false,
            testResult: response,
            testSuccess: true,
          ),
        );
      } catch (e) {
        // エラー発生時はテスト失敗として記録
        emit(
          currentState.copyWith(
            geminiApiKey: event.apiKey,
            isTesting: false,
            testResult: e.toString(),
            testSuccess: false,
          ),
        );
      }
    }
  }
}
