import 'package:tick_mate_t3/config/app_config.dart';
import 'package:tick_mate_t3/data/datasources/remote/http_client.dart';

/// API通信の基本クラス
abstract class BaseApiClient {
  final HttpClient _httpClient;
  final AppConfig _config;

  BaseApiClient(this._httpClient, this._config) {
    _initialize();
  }

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

  /// GETリクエストを送信
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _httpClient.get(path, queryParameters: queryParameters);
  }

  /// POSTリクエストを送信
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _httpClient.post(path, data: data, queryParameters: queryParameters);
  }

  /// PUTリクエストを送信
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _httpClient.put(path, data: data, queryParameters: queryParameters);
  }

  /// DELETEリクエストを送信
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _httpClient.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }
}
