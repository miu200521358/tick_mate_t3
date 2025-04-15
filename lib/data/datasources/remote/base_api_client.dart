import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/data/datasources/remote/http_client.dart';

/// API通信の基本クラス
abstract class BaseApiClient {
  BaseApiClient(this._httpClient, this._config) {
    _initialize();
  }

  final HttpClient _httpClient;
  final AppConfig _config;

  /// APIクライアントの初期化
  void _initialize() {
    _httpClient.setBaseUrl(_config.baseUrl);
    _setupCommonHeaders();
  }

  /// 共通ヘッダーの設定
  void _setupCommonHeaders() {
    _httpClient.setHeaders({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-version': _config.apiVersion,
    });
  }

  /// エラー通知コールバック型定義
  typedef OnErrorCallback = void Function(Exception error, String requestPath);

  /// GETリクエストを送信
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    OnErrorCallback? onError,
  }) async {
    return _httpClient.get(
      path, 
      queryParameters: queryParameters,
      onError: onError,
    );
  }

  /// POSTリクエストを送信
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    OnErrorCallback? onError,
  }) async {
    return _httpClient.post(
      path, 
      data: data, 
      queryParameters: queryParameters,
      onError: onError,
    );
  }

  /// PUTリクエストを送信
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    OnErrorCallback? onError,
  }) async {
    return _httpClient.put(
      path, 
      data: data, 
      queryParameters: queryParameters,
      onError: onError,
    );
  }

  /// DELETEリクエストを送信
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    OnErrorCallback? onError,
  }) async {
    return _httpClient.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      onError: onError,
    );
  }
}
