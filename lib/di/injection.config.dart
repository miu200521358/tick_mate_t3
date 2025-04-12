// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:math' as _i407;

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tick_mate_t3/config/app_config.dart' as _i777;
import 'package:tick_mate_t3/config/config_dev.dart' as _i760;
import 'package:tick_mate_t3/config/config_prod.dart' as _i203;
import 'package:tick_mate_t3/config/config_stg.dart' as _i623;
import 'package:tick_mate_t3/data/datasources/local/local_storage_datasource.dart'
    as _i570;
import 'package:tick_mate_t3/data/datasources/local/secure_storage_datasource.dart'
    as _i676;
import 'package:tick_mate_t3/data/datasources/remote/gemini_api_client.dart'
    as _i470;
import 'package:tick_mate_t3/data/datasources/remote/gemini_api_datasource.dart'
    as _i534;
import 'package:tick_mate_t3/data/datasources/remote/http_client.dart' as _i240;
import 'package:tick_mate_t3/data/datasources/remote/interceptors/logging_interceptor.dart'
    as _i818;
import 'package:tick_mate_t3/data/datasources/remote/interceptors/retry_interceptor.dart'
    as _i458;
import 'package:tick_mate_t3/data/repositories/character_repository_impl.dart'
    as _i245;
import 'package:tick_mate_t3/data/repositories/notification_history_repository_impl.dart'
    as _i672;
import 'package:tick_mate_t3/data/repositories/subscription_repository_impl.dart'
    as _i181;
import 'package:tick_mate_t3/data/repositories/timer_repository_impl.dart'
    as _i971;
import 'package:tick_mate_t3/data/repositories/work_repository_impl.dart'
    as _i393;
import 'package:tick_mate_t3/di/app_module.dart' as _i865;
import 'package:tick_mate_t3/di/settings_module.dart' as _i716;
import 'package:tick_mate_t3/domain/repositories/character_repository.dart'
    as _i62;
import 'package:tick_mate_t3/domain/repositories/notification_history_repository.dart'
    as _i655;
import 'package:tick_mate_t3/domain/repositories/subscription_repository.dart'
    as _i60;
import 'package:tick_mate_t3/domain/repositories/timer_repository.dart'
    as _i200;
import 'package:tick_mate_t3/domain/repositories/work_repository.dart' as _i896;
import 'package:tick_mate_t3/domain/usecases/character/select_character_usecase.dart'
    as _i758;
import 'package:tick_mate_t3/domain/usecases/notification/create_notification_usecase.dart'
    as _i891;
import 'package:tick_mate_t3/domain/usecases/timer/create_timer_usecase.dart'
    as _i802;
import 'package:tick_mate_t3/domain/usecases/timer/get_timers_usecase.dart'
    as _i194;
import 'package:tick_mate_t3/presentation/bloc/settings/settings_bloc.dart'
    as _i485;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    final settingsModule = _$SettingsModule();
    gh.factory<_i818.LoggingInterceptor>(() => _i818.LoggingInterceptor());
    gh.lazySingleton<_i570.LocalStorageDataSource>(
        () => _i570.LocalStorageDataSource());
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.lazySingleton<_i407.Random>(() => appModule.random);
    gh.lazySingleton<_i60.SubscriptionRepository>(
        () => _i181.SubscriptionRepositoryImpl());
    gh.factory<_i458.RetryInterceptor>(() => _i458.RetryInterceptor(
          maxRetries: gh<int>(),
          retryDelay: gh<Duration>(),
        ));
    gh.lazySingleton<_i777.AppConfig>(
      () => _i760.DevConfig(),
      instanceName: 'dev',
    );
    gh.lazySingleton<_i777.AppConfig>(
      () => _i623.StgConfig(),
      instanceName: 'stg',
    );
    gh.lazySingleton<_i777.AppConfig>(
      () => _i203.ProdConfig(),
      instanceName: 'prod',
    );
    gh.lazySingleton<_i676.SecureStorageDataSource>(
        () => _i676.SecureStorageDataSource(gh<_i558.FlutterSecureStorage>()));
    gh.lazySingleton<_i240.HttpClient>(() => _i240.HttpClient(
          gh<_i361.Dio>(),
          gh<_i818.LoggingInterceptor>(),
          gh<_i458.RetryInterceptor>(),
        ));
    gh.lazySingleton<_i62.CharacterRepository>(() =>
        _i245.CharacterRepositoryImpl(gh<_i570.LocalStorageDataSource>()));
    gh.lazySingleton<_i655.NotificationHistoryRepository>(() =>
        _i672.NotificationHistoryRepositoryImpl(
            gh<_i570.LocalStorageDataSource>()));
    gh.lazySingleton<_i896.WorkRepository>(
        () => _i393.WorkRepositoryImpl(gh<_i570.LocalStorageDataSource>()));
    gh.lazySingleton<_i200.TimerRepository>(
        () => _i971.TimerRepositoryImpl(gh<_i570.LocalStorageDataSource>()));
    gh.lazySingleton<_i470.GeminiApiClient>(() => _i470.GeminiApiClient(
          gh<_i240.HttpClient>(),
          gh<_i777.AppConfig>(instanceName: 'dev'),
          gh<_i676.SecureStorageDataSource>(),
        ));
    gh.factory<_i891.CreateNotificationUseCase>(() =>
        _i891.CreateNotificationUseCase(
            gh<_i655.NotificationHistoryRepository>()));
    gh.factory<_i758.SelectCharacterUseCase>(() => _i758.SelectCharacterUseCase(
          gh<_i62.CharacterRepository>(),
          gh<_i407.Random>(),
        ));
    gh.factory<_i802.CreateTimerUseCase>(
        () => _i802.CreateTimerUseCase(gh<_i200.TimerRepository>()));
    gh.factory<_i194.GetTimersUseCase>(
        () => _i194.GetTimersUseCase(gh<_i200.TimerRepository>()));
    gh.lazySingleton<_i534.GeminiApiDataSource>(
        () => _i534.GeminiApiDataSource(gh<_i470.GeminiApiClient>()));
    gh.factory<_i485.SettingsBloc>(() => settingsModule.provideSettingsBloc(
          gh<_i676.SecureStorageDataSource>(),
          gh<_i534.GeminiApiDataSource>(),
        ));
    return this;
  }
}

class _$AppModule extends _i865.AppModule {}

class _$SettingsModule extends _i716.SettingsModule {}
