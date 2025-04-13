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

import '../config/app_config.dart' as _i650;
import '../config/config_default.dart' as _i792;
import '../config/config_dev.dart' as _i125;
import '../config/config_prod.dart' as _i941;
import '../config/config_stg.dart' as _i277;
import '../core/services/notification_service.dart' as _i570;
import '../data/datasources/local/local_storage_datasource.dart' as _i462;
import '../data/datasources/local/secure_storage_datasource.dart' as _i848;
import '../data/datasources/remote/gemini_api_client.dart' as _i110;
import '../data/datasources/remote/gemini_api_datasource.dart' as _i80;
import '../data/datasources/remote/http_client.dart' as _i125;
import '../data/datasources/remote/interceptors/logging_interceptor.dart'
    as _i597;
import '../data/datasources/remote/interceptors/retry_interceptor.dart'
    as _i554;
import '../data/repositories/character_repository_impl.dart' as _i286;
import '../data/repositories/notification_history_repository_impl.dart'
    as _i279;
import '../data/repositories/subscription_repository_impl.dart' as _i762;
import '../data/repositories/timer_repository_impl.dart' as _i209;
import '../data/repositories/work_repository_impl.dart' as _i895;
import '../domain/repositories/character_repository.dart' as _i357;
import '../domain/repositories/notification_history_repository.dart' as _i695;
import '../domain/repositories/subscription_repository.dart' as _i804;
import '../domain/repositories/timer_repository.dart' as _i973;
import '../domain/repositories/work_repository.dart' as _i47;
import '../domain/usecases/character/select_character_usecase.dart' as _i814;
import '../domain/usecases/notification/create_notification_usecase.dart'
    as _i797;
import '../domain/usecases/timer/create_timer_usecase.dart' as _i890;
import '../domain/usecases/timer/get_timers_usecase.dart' as _i563;
import '../presentation/bloc/settings/settings_bloc.dart' as _i366;
import 'app_module.dart' as _i460;
import 'settings_module.dart' as _i971;

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
    gh.factory<_i597.LoggingInterceptor>(() => _i597.LoggingInterceptor());
    gh.lazySingleton<_i462.LocalStorageDataSource>(
        () => _i462.LocalStorageDataSource());
    gh.lazySingleton<_i361.Dio>(() => appModule.dio);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => appModule.secureStorage);
    gh.lazySingleton<_i407.Random>(() => appModule.random);
    gh.lazySingleton<_i650.AppConfig>(
      () => _i125.DevConfig(),
      instanceName: 'dev',
    );
    gh.lazySingleton<_i47.WorkRepository>(
        () => _i895.WorkRepositoryImpl(gh<_i462.LocalStorageDataSource>()));
    gh.lazySingleton<_i650.AppConfig>(
      () => _i277.StgConfig(),
      instanceName: 'stg',
    );
    gh.lazySingleton<_i650.AppConfig>(
      () => _i941.ProdConfig(),
      instanceName: 'prod',
    );
    gh.factory<_i554.RetryInterceptor>(() => _i554.RetryInterceptor(
          maxRetries: gh<int>(),
          retryDelay: gh<Duration>(),
        ));
    gh.lazySingleton<_i650.AppConfig>(() => _i792.DefaultConfig());
    gh.lazySingleton<_i695.NotificationHistoryRepository>(() =>
        _i279.NotificationHistoryRepositoryImpl(
            gh<_i462.LocalStorageDataSource>()));
    gh.lazySingleton<_i357.CharacterRepository>(() =>
        _i286.CharacterRepositoryImpl(gh<_i462.LocalStorageDataSource>()));
    gh.factory<_i797.CreateNotificationUseCase>(() =>
        _i797.CreateNotificationUseCase(
            gh<_i695.NotificationHistoryRepository>()));
    gh.lazySingleton<_i973.TimerRepository>(
        () => _i209.TimerRepositoryImpl(gh<_i462.LocalStorageDataSource>()));
    gh.lazySingleton<_i804.SubscriptionRepository>(
        () => _i762.SubscriptionRepositoryImpl());
    gh.lazySingleton<_i848.SecureStorageDataSource>(
        () => _i848.SecureStorageDataSource(gh<_i558.FlutterSecureStorage>()));
    gh.factory<_i125.HttpClient>(() => appModule.provideHttpClient(
          gh<_i361.Dio>(),
          gh<_i597.LoggingInterceptor>(),
          gh<_i554.RetryInterceptor>(),
        ));
    gh.factory<_i814.SelectCharacterUseCase>(() => _i814.SelectCharacterUseCase(
          gh<_i357.CharacterRepository>(),
          gh<_i407.Random>(),
        ));
    gh.factory<_i890.CreateTimerUseCase>(
        () => _i890.CreateTimerUseCase(gh<_i973.TimerRepository>()));
    gh.factory<_i563.GetTimersUseCase>(
        () => _i563.GetTimersUseCase(gh<_i973.TimerRepository>()));
    gh.lazySingleton<_i110.GeminiApiClient>(
        () => appModule.provideGeminiApiClient(
              gh<_i125.HttpClient>(),
              gh<_i650.AppConfig>(),
              gh<_i848.SecureStorageDataSource>(),
            ));
    gh.lazySingleton<_i570.NotificationService>(
        () => _i570.NotificationService(gh<_i797.CreateNotificationUseCase>()));
    gh.lazySingleton<_i80.GeminiApiDataSource>(() => _i80.GeminiApiDataSource(
          gh<_i110.GeminiApiClient>(),
          gh<_i848.SecureStorageDataSource>(),
        ));
    gh.factory<_i366.SettingsBloc>(() => settingsModule.provideSettingsBloc(
          gh<_i848.SecureStorageDataSource>(),
          gh<_i80.GeminiApiDataSource>(),
        ));
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}

class _$SettingsModule extends _i971.SettingsModule {}
