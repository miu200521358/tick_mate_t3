import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate/core/services/error_handler_service.dart';
import 'package:tick_mate/l10n/app_localizations.dart';

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
  /// [context] BuildContext（多言語対応のため）
  /// [messageKey] 多言語対応のメッセージキー
  /// [silent] UIに通知を表示しないかどうか
  /// [recordToCrashlytics] Crashlyticsに記録するかどうか
  static Future<T?> handle<T, B, S>({
    required B bloc,
    required Emitter<S> emit,
    required S Function(String errorMessage) errorStateBuilder,
    required Future<T> Function() function,
    String? message,
    BuildContext? context,
    String? messageKey,
    bool silent = false,
    bool recordToCrashlytics = true,
  }) async {
    // 非同期操作前にBuildContextから必要な情報をすべて取得
    String? localizedMessage;
    if (context != null && messageKey != null) {
      localizedMessage = _getLocalizedMessage(context, messageKey);
    }

    try {
      return await function();
    } catch (e, stackTrace) {
      final errorMessage = await _errorHandler.handleError(
        e,
        stackTrace: stackTrace,
        message: localizedMessage ?? message,
        silent: silent,
        recordToCrashlytics: recordToCrashlytics,
      );

      // エラー状態をemit
      emit(errorStateBuilder(errorMessage));
      return null;
    }
  }

  /// メッセージキーに基づいてローカライズされたメッセージを取得
  ///
  /// [context] BuildContext
  /// [messageKey] メッセージキー
  ///
  /// 注意: このメソッドは非同期ギャップの前に呼び出す必要があります
  static String? _getLocalizedMessage(BuildContext context, String messageKey) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return null;

    switch (messageKey) {
      case 'errorLoadingTimers':
        return l10n.errorLoadingTimers;
      case 'errorCreatingTimer':
        return l10n.errorCreatingTimer;
      case 'errorDeletingTimer':
        return l10n.errorDeletingTimer;
      case 'errorLoadingWorkList':
        return l10n.errorLoadingWorkList('');
      default:
        return null;
    }
  }
}
