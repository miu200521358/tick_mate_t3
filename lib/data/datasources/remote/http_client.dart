import 'package:dio/dio.dart';
import 'package:tick_mate_t3/core/error/exceptions.dart';
import 'package:tick_mate_t3/data/datasources/remote/interceptors/logging_interceptor.dart';
import 'package:tick_mate_t3/data/datasources/remote/interceptors/retry_interceptor.dart';

/// DioをラップするカスタムHTTPクライアント
class HttpClient {
  HttpClient(this._dio, this._loggingInterceptor, this._retryInterceptor) {
    _dio.interceptors.addAll([_loggingInterceptor, _retryInterceptor]);

    // デフォルトのタイムアウト設定
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);
  }

  final Dio _dio;
  final LoggingInterceptor _loggingInterceptor;
  final RetryInterceptor _retryInterceptor;

  /// リクエストオプションを準備
  Options _prepareOptions(Options? options) {
    final requestOptions = options ?? Options();
    // リトライ用にDioインスタンスを保存
    requestOptions.extra = {...requestOptions.extra ?? {}, 'dio': _dio};
    return requestOptions;
  }

  /// GETリクエストを送信
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: _prepareOptions(options),
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POSTリクエストを送信
  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _prepareOptions(options),
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUTリクエストを送信
  Future<dynamic> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _prepareOptions(options),
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETEリクエストを送信
  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _prepareOptions(options),
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// エラーハンドリング
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('通信タイムアウトが発生しました', e.stackTrace);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return ServerException('サーバーエラーが発生しました: $statusCode', e.stackTrace);
          } else if (statusCode == 401) {
            return AuthenticationException('認証エラーが発生しました', e.stackTrace);
          } else if (statusCode == 403) {
            return AuthenticationException('アクセス権限がありません', e.stackTrace);
          } else if (statusCode == 404) {
            return ServerException('リソースが見つかりませんでした', e.stackTrace);
          }
        }
        return ServerException(
          '予期しないレスポンスエラーが発生しました: ${e.response?.statusCode}',
          e.stackTrace,
        );
      case DioExceptionType.cancel:
        return ServerException('リクエストがキャンセルされました', e.stackTrace);
      default:
        return NetworkException('通信エラーが発生しました: ${e.message}', e.stackTrace);
    }
  }

  /// 共通ヘッダーを設定
  void setHeaders(Map<String, String> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// ベースURLを設定
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
