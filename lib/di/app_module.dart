import 'dart:math' show Random;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/config/app_config.dart';
import 'package:tick_mate_t3/core/services/notification_service.dart';
import 'package:tick_mate_t3/data/datasources/local/secure_storage_datasource.dart';
import 'package:tick_mate_t3/data/datasources/remote/gemini_api_client.dart';
import 'package:tick_mate_t3/data/datasources/remote/http_client.dart';
import 'package:tick_mate_t3/data/datasources/remote/interceptors/logging_interceptor.dart';
import 'package:tick_mate_t3/data/datasources/remote/interceptors/retry_interceptor.dart';
import 'package:tick_mate_t3/domain/usecases/notification/create_notification_usecase.dart';

/// 外部ライブラリの依存関係を提供するモジュール
@module
abstract class AppModule {
  /// Dioインスタンスを提供
  @lazySingleton
  Dio get dio => Dio();

  /// FlutterSecureStorageインスタンスを提供
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  /// Randomインスタンスを提供
  @lazySingleton
  Random get random => Random();

  /// HttpClientインスタンスを提供
  HttpClient provideHttpClient(
    Dio dio,
    LoggingInterceptor loggingInterceptor,
    RetryInterceptor retryInterceptor,
  ) => HttpClient(dio, loggingInterceptor, retryInterceptor);

  /// GeminiApiClientを環境に応じて提供
  @lazySingleton
  GeminiApiClient provideGeminiApiClient(
    HttpClient httpClient,
    AppConfig config, // 環境に応じた適切なAppConfigが注入される
    SecureStorageDataSource secureStorage,
  ) => GeminiApiClient(httpClient, config, secureStorage);

  /// 通知サービスを提供
  @lazySingleton
  NotificationService provideNotificationService(
    CreateNotificationUseCase createNotificationUseCase,
  ) {
    return NotificationService(createNotificationUseCase);
  }
}
