import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/data/datasources/local/secure_storage_datasource.dart';
import 'package:tick_mate_t3/data/datasources/remote/gemini_api_datasource.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_bloc.dart';

/// 設定モジュール
@module
abstract class SettingsModule {
  /// SettingsBloc
  @injectable
  SettingsBloc provideSettingsBloc(
    SecureStorageDataSource secureStorageDataSource,
    GeminiApiDataSource geminiApiDataSource,
  ) => SettingsBloc(secureStorageDataSource, geminiApiDataSource);
}
