import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/core/log/logger.dart';

/// リトライ機能を提供するインターセプター
@injectable
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  final int maxRetries;
  final Duration retryDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    // リトライカウントを取得
    options.extra['retryCount'] ??= 0;
    final int retryCount = options.extra['retryCount'];

    // リトライ可能なエラーかチェック
    final bool shouldRetry = _shouldRetry(err) && retryCount < maxRetries;

    if (shouldRetry) {
      options.extra['retryCount'] = retryCount + 1;

      Logger.i('リトライ実行 (${retryCount + 1}/$maxRetries): ${options.path}');

      // 一定時間待機
      await Future.delayed(retryDelay);

      // リクエストを再実行
      try {
        // Dioインスタンスを取得
        final dio = err.requestOptions.extra['dio'] as Dio?;
        if (dio != null) {
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } else {
          Logger.e('Dioインスタンスが見つかりません');
          return super.onError(err, handler);
        }
      } on DioException catch (e) {
        return super.onError(e, handler);
      }
    }

    return super.onError(err, handler);
  }

  /// リトライ可能なエラーかどうかを判定
  bool _shouldRetry(DioException err) {
    return err.error is SocketException ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}
