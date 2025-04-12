import 'package:equatable/equatable.dart';

/// 設定画面BLoCの状態基底クラス
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// 設定画面初期状態
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// 設定画面読み込み中状態
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// 設定画面読み込み完了状態
class SettingsLoaded extends SettingsState {
  final String? geminiApiKey;
  final bool isTesting;
  final String? testResult;
  final bool? testSuccess;

  const SettingsLoaded({
    this.geminiApiKey,
    this.isTesting = false,
    this.testResult,
    this.testSuccess,
  });

  SettingsLoaded copyWith({
    String? geminiApiKey,
    bool? isTesting,
    String? testResult,
    bool? testSuccess,
  }) {
    return SettingsLoaded(
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      isTesting: isTesting ?? this.isTesting,
      testResult: testResult ?? this.testResult,
      testSuccess: testSuccess ?? this.testSuccess,
    );
  }

  @override
  List<Object?> get props => [geminiApiKey, isTesting, testResult, testSuccess];
}

/// 設定画面エラー状態
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}
