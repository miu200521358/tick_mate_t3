import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/core/error/exceptions.dart';
import 'package:tick_mate/core/utils/log/log_util.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';

/// エラーハンドラサービス
/// アプリケーション全体でのエラー処理を統一的に行うためのサービス
@lazySingleton
class ErrorHandlerService {
  /// エラーを処理し、適切な処理を行う
  ///
  /// [exception] 発生した例外
  /// [stackTrace] スタックトレース
  /// [message] エラーメッセージ（オプション）
  /// [fatal] 致命的なエラーかどうか
  /// [silent] UIに通知を表示しないかどうか
  /// [recordToCrashlytics] Crashlyticsに記録するかどうか
  ///
  /// 戻り値: エラーメッセージ（ユーザー表示用）
  Future<String> handleError(
    dynamic exception, {
    StackTrace? stackTrace,
    String? message,
    bool fatal = false,
    bool silent = false,
    bool recordToCrashlytics = true,
  }) async {
    // 例外をAppException型に変換
    final appException = _convertToAppException(
      exception,
      stackTrace: stackTrace,
      message: message,
    );

    // ログに記録
    LogUtil.e('エラーが発生しました: ${appException.message}', appException, stackTrace);

    // Crashlyticsに記録（オプション）
    if (recordToCrashlytics) {
      await appException.recordToCrashlytics(fatal: fatal);
    }

    // ユーザー向けメッセージを取得
    return _getUserFriendlyMessage(appException);
  }

  /// 例外をキャッチして処理するための共通関数
  ///
  /// [function] 実行する関数
  /// [onError] エラー時のコールバック関数
  /// [message] エラーメッセージ（オプション）
  /// [silent] UIに通知を表示しないかどうか
  /// [recordToCrashlytics] Crashlyticsに記録するかどうか
  ///
  /// 戻り値: 関数の戻り値またはnull（エラー時）
  Future<T?> tryCatch<T>(
    Future<T> Function() function, {
    Function(String errorMessage)? onError,
    String? message,
    bool silent = false,
    bool recordToCrashlytics = true,
  }) async {
    try {
      return await function();
    } catch (e, stackTrace) {
      final errorMessage = await handleError(
        e,
        stackTrace: stackTrace,
        message: message,
        silent: silent,
        recordToCrashlytics: recordToCrashlytics,
      );

      // エラーコールバックがある場合は実行
      if (onError != null) {
        onError(errorMessage);
      }

      return null;
    }
  }

  /// SnackBarでエラーメッセージを表示
  ///
  /// [context] BuildContext
  /// [message] 表示するメッセージ
  /// [duration] 表示時間
  /// [action] SnackBarのアクション（オプション）
  /// [onRetry] 再試行ボタン押下時のコールバック
  void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    VoidCallback? onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action ?? _createRetryAction(context, onRetry),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  /// AlertDialogでエラーメッセージを表示
  ///
  /// [context] BuildContext
  /// [title] ダイアログのタイトル
  /// [message] 表示するメッセージ
  /// [onConfirm] OKボタン押下時のコールバック
  void showErrorDialog(
    BuildContext context,
    String message, {
    String? title,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(title ?? l10n.error(''), textAlign: TextAlign.center),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(l10n.ok),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (onConfirm != null) {
                  onConfirm();
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// 例外をAppException型に変換
  AppException _convertToAppException(
    dynamic exception, {
    StackTrace? stackTrace,
    String? message,
  }) {
    if (exception is AppException) {
      return exception;
    } else if (exception is ArgumentError) {
      return ValidationException(
        message ?? exception.message.toString(),
        stackTrace,
      );
    } else {
      return AppException(message ?? exception.toString(), stackTrace);
    }
  }

  /// ユーザーフレンドリーなエラーメッセージを取得
  String _getUserFriendlyMessage(AppException exception) {
    // 例外の種類に応じたメッセージを返す
    if (exception is ValidationException) {
      return exception.message;
    }

    // BuildContextがないため、ここではハードコードされた文字列を返す
    // 実際の表示時にはAppLocalizationsを使用して多言語対応する
    return exception.message;
  }

  /// 例外の種類に応じたローカライズされたエラーメッセージを取得
  String getLocalizedErrorMessage(
    BuildContext context,
    AppException exception,
  ) {
    final l10n = AppLocalizations.of(context)!;

    // 例外の種類に応じたメッセージを返す
    if (exception is ServerException) {
      return l10n.errorServerMessage;
    } else if (exception is NetworkException) {
      return l10n.errorNetworkMessage;
    } else if (exception is TimeoutException) {
      return l10n.errorTimeoutMessage;
    } else if (exception is ValidationException) {
      return exception.message;
    } else if (exception is CacheException) {
      return l10n.errorCacheMessage;
    } else if (exception is AuthenticationException) {
      return l10n.errorAuthMessage;
    } else {
      return l10n.errorDefaultMessage;
    }
  }

  /// 「再試行」アクションを作成
  ///
  /// [context] BuildContext
  /// [onRetry] 再試行ボタン押下時のコールバック
  SnackBarAction? _createRetryAction(
    BuildContext context,
    VoidCallback? onRetry,
  ) {
    return SnackBarAction(
      label: AppLocalizations.of(context)!.retry,
      onPressed: () {
        // 再試行処理を実行
        if (onRetry != null) {
          onRetry();
        }
      },
    );
  }
}
