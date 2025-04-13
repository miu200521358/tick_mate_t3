import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/core/error/exceptions.dart';
import 'package:tick_mate/core/log/logger.dart';
import 'package:tick_mate/l10n/app_localizations.dart';

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
    Logger.e('エラーが発生しました: ${appException.message}', appException, stackTrace);

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
  void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action ?? _createRetryAction(context),
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
        return AlertDialog(
          title: Text(
            title ?? AppLocalizations.of(context)!.error(''),
            textAlign: TextAlign.center,
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
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
    if (exception is ServerException) {
      return 'サーバーとの通信中にエラーが発生しました。';
    } else if (exception is NetworkException) {
      return 'ネットワーク接続に問題があります。インターネット接続を確認してください。';
    } else if (exception is TimeoutException) {
      return 'サーバーからの応答がありません。時間をおいて再度お試しください。';
    } else if (exception is ValidationException) {
      return exception.message;
    } else if (exception is CacheException) {
      return 'データの読み込みに失敗しました。';
    } else if (exception is AuthenticationException) {
      return '認証に失敗しました。再度ログインしてください。';
    } else {
      return '予期せぬエラーが発生しました。';
    }
  }

  /// 「再試行」アクションを作成
  SnackBarAction? _createRetryAction(BuildContext context) {
    return SnackBarAction(
      label: AppLocalizations.of(context)!.retry,
      onPressed: () {
        // 再試行処理は呼び出し元で実装
      },
    );
  }
}
