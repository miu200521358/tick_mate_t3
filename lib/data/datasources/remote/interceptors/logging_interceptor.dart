import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/core/log/logger.dart';

/// APIリクエスト/レスポンスのログを出力するインターセプター
@injectable
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Logger.i(
      'REQUEST[${options.method}] => PATH: ${options.path}\n'
      'HEADERS: ${options.headers}\n'
      'BODY: ${options.data}',
    );
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.i(
      'RESPONSE[${response.statusCode}] <= PATH: ${response.requestOptions.path}\n'
      'BODY: ${response.data}',
    );
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}\n'
      'MESSAGE: ${err.message}\n'
      'ERROR: ${err.error}\n'
      'RESPONSE: ${err.response?.data}',
    );
    return super.onError(err, handler);
  }
}
