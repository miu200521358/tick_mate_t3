import 'package:equatable/equatable.dart';

/// 設定画面BLoCのイベント基底クラス
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// 設定画面初期化イベント
class SettingsInitialized extends SettingsEvent {
  const SettingsInitialized();
}

/// Gemini APIキー保存イベント
class GeminiApiKeySaved extends SettingsEvent {
  const GeminiApiKeySaved({required this.apiKey});

  final String apiKey;

  @override
  List<Object> get props => [apiKey];
}

/// Gemini APIキー削除イベント
class GeminiApiKeyDeleted extends SettingsEvent {
  const GeminiApiKeyDeleted();
}

/// Gemini APIキーテストイベント
class GeminiApiKeyTested extends SettingsEvent {
  const GeminiApiKeyTested({required this.apiKey});

  final String apiKey;

  @override
  List<Object> get props => [apiKey];
}
