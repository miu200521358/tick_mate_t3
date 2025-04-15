import 'package:dio/dio.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/core/error/exceptions.dart';
import 'package:tick_mate/data/datasources/remote/interceptors/auth_interceptor.dart';
import 'package:tick_mate/data/datasources/remote/interceptors/logging_interceptor.dart';
import 'package:tick_mate/data/datasources/remote/interceptors/retry_interceptor.dart';

/// エラー通知コールバック型定義
typedef OnErrorCallback = void Function(Exception error, String requestPath);

/// DioをラップするカスタムHTTPクライアント
class HttpClient {
  HttpClient(
    this._dio,
    this._loggingInterceptor,
    this._retryInterceptor,
    this._authInterceptor,
    this._config,
  ) {
    _dio.interceptors.addAll([
      _loggingInterceptor,
      _retryInterceptor,
      _authInterceptor,
    ]);

    // configからデフォルトのタイムアウト設定を適用
    _dio.options.connectTimeout = _config.defaultConnectTimeout;
    _dio.options.receiveTimeout = _config.defaultReceiveTimeout;
    _dio.options.sendTimeout = _config.defaultSendTimeout;
  }

  final Dio _dio;
  final LoggingInterceptor _loggingInterceptor;
  final RetryInterceptor _retryInterceptor;
  final AuthInterceptor _authInterceptor;
  final AppConfig _config;

  /// エラー通知コールバック
  void Function(Exception error, String requestPath)? _onErrorCallback;

  /// エラー通知コールバックを設定
  void setOnErrorCallback(
    void Function(Exception error, String requestPath) callback,
  ) {
    _onErrorCallback = callback;
  }

  /// リクエストオプションを準備
  Options _prepareOptions(Options? options) {
    final requestOptions = options ?? Options();
    // リトライ用にDioインスタンスを保存
    requestOptions.extra = {...requestOptions.extra ?? {}, 'dio': _dio};
    return requestOptions;
  }

  /// APIごとの特別なタイムアウト設定を適用
  void setCustomTimeout({
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    if (connectTimeout != null) {
      _dio.options.connectTimeout = connectTimeout;
    }
    if (receiveTimeout != null) {
      _dio.options.receiveTimeout = receiveTimeout;
    }
    if (sendTimeout != null) {
      _dio.options.sendTimeout = sendTimeout;
    }
  }

  /// デフォルトのタイムアウト設定に戻す
  void resetToDefaultTimeout() {
    _dio.options.connectTimeout = _config.defaultConnectTimeout;
    _dio.options.receiveTimeout = _config.defaultReceiveTimeout;
    _dio.options.sendTimeout = _config.defaultSendTimeout;
  }

  /// GETリクエストを送信
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(Exception error, String requestPath)? onError,
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
      final error = _handleError(e);

      // ローカルのエラーコールバックがある場合は実行
      if (onError != null) {
        onError(error, url);
      }
      // グローバルのエラーコールバックがある場合は実行
      else if (_onErrorCallback != null) {
        _onErrorCallback!(error, url);
      }

      throw error;
    }
  }

  /// POSTリクエストを送信
  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(Exception error, String requestPath)? onError,
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
      final error = _handleError(e);

      // ローカルのエラーコールバックがある場合は実行
      if (onError != null) {
        onError(error, url);
      }
      // グローバルのエラーコールバックがある場合は実行
      else if (_onErrorCallback != null) {
        _onErrorCallback!(error, url);
      }

      throw error;
    }
  }

  /// PUTリクエストを送信
  Future<dynamic> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(Exception error, String requestPath)? onError,
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
      final error = _handleError(e);

      // ローカルのエラーコールバックがある場合は実行
      if (onError != null) {
        onError(error, url);
      }
      // グローバルのエラーコールバックがある場合は実行
      else if (_onErrorCallback != null) {
        _onErrorCallback!(error, url);
      }

      throw error;
    }
  }

  /// DELETEリクエストを送信
  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(Exception error, String requestPath)? onError,
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
      final error = _handleError(e);

      // ローカルのエラーコールバックがある場合は実行
      if (onError != null) {
        onError(error, url);
      }
      // グローバルのエラーコールバックがある場合は実行
      else if (_onErrorCallback != null) {
        _onErrorCallback!(error, url);
      }

      throw error;
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
