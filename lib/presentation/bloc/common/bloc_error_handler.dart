import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/core/services/error_handler_service.dart';

/// BLoCエラーハンドラー
/// BLoC内でのエラー処理を統一的に行うためのユーティリティ
class BlocErrorHandler {
  static final _errorHandler = GetIt.instance<ErrorHandlerService>();

  /// BLoC内でエラーを処理するための共通関数
  ///
  /// [bloc] BLoCインスタンス
  /// [emit] エミッタ
  /// [errorStateBuilder] エラー状態を生成する関数
  /// [function] 実行する関数
  /// [message] エラーメッセージ（オプション）
  /// [silent] UIに通知を表示しないかどうか
  /// [recordToCrashlytics] Crashlyticsに記録するかどうか
  static Future<T?> handle<T, B, S>({
    required B bloc,
    required Emitter<S> emit,
    required S Function(String errorMessage) errorStateBuilder,
    required Future<T> Function() function,
    String? message,
    bool silent = false,
    bool recordToCrashlytics = true,
  }) async {
    try {
      return await function();
    } catch (e, stackTrace) {
      final errorMessage = await _errorHandler.handleError(
        e,
        stackTrace: stackTrace,
        message: message,
        silent: silent,
        recordToCrashlytics: recordToCrashlytics,
      );

      // エラー状態をemit
      emit(errorStateBuilder(errorMessage));
      return null;
    }
  }
}
