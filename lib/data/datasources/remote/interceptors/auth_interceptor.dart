import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/core/utils/log/log_util.dart';

/// 認証トークンを付与するインターセプター
@injectable
class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  /// トークンを保持する変数
  String? _authToken;

  /// 認証トークンを設定
  void setToken(String token) {
    _authToken = token;
    LogUtil.i('認証トークンを設定しました');
  }

  /// 認証トークンをクリア
  void clearToken() {
    _authToken = null;
    LogUtil.i('認証トークンをクリアしました');
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // トークンが設定されている場合は、ヘッダーに追加
    if (_authToken != null && _authToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_authToken';
    }

    // リクエストに認証が必要かどうかのフラグを確認
    final requiresAuth = options.extra['requiresAuth'] as bool? ?? true;
    
    // 認証が必要だが、トークンが設定されていない場合
    if (requiresAuth && (_authToken == null || _authToken!.isEmpty)) {
      LogUtil.w('認証が必要ですが、トークンが設定されていません: ${options.path}');
      // 認証エラーを返すことも可能だが、ここではリクエストを続行
      // 実際のAPIがエラーを返すことを期待
    }

    return super.onRequest(options, handler);
  }
}
