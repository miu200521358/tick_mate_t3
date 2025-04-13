// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'TickMate';

  @override
  String error(String message) {
    return 'エラー: $message';
  }

  @override
  String get unknown => '不明な状態です';

  @override
  String get retry => '再試行';

  @override
  String get loading => '読み込み中...';

  @override
  String get loadingCharacter => 'キャラクター情報を読み込んでいます...';

  @override
  String get noTimers => 'タイマーがありません。追加してください。';

  @override
  String get addTimer => 'タイマーを追加';

  @override
  String get settings => '設定';

  @override
  String get geminiApiKeySettings => 'Gemini APIキー設定';

  @override
  String get geminiApiKeyDescription => 'Google Gemini APIキーを入力してください。APIキーはデバイスのセキュアストレージに保存され、アプリ内でのみ使用されます。';

  @override
  String get geminiApiKey => 'Gemini APIキー';

  @override
  String get enterApiKey => 'APIキーを入力';

  @override
  String get saveApiKey => 'APIキーを保存';

  @override
  String get deleteApiKey => 'APIキーを削除';

  @override
  String get connectionTest => '接続テスト';

  @override
  String get testSuccess => 'テスト成功';

  @override
  String get testFailure => 'テスト失敗';

  @override
  String get selectFromGallery => 'ギャラリーから選択';

  @override
  String createdAt(String date) {
    return '作成日: $date';
  }

  @override
  String updatedAt(String date) {
    return '更新日: $date';
  }

  @override
  String errorLoadingWorkList(String message) {
    return '作品リストの読み込みに失敗しました: $message';
  }

  @override
  String get apiKeyNotSet => 'Gemini APIキーが設定されていません';

  @override
  String get timerTab => 'タイマー';

  @override
  String get notificationTab => '通知履歴';

  @override
  String get characterTab => 'キャラクター';

  @override
  String get settingsTab => '設定';

  @override
  String get workList => '作品リスト';

  @override
  String get noWorks => '作品がありません。';

  @override
  String get workListScreen => '作品リスト画面';

  @override
  String get workInfo => '作品情報:';

  @override
  String get characterList => 'キャラクターリスト:';

  @override
  String get noCharactersInWork => 'この作品にはキャラクターがいません。';

  @override
  String get workDetailScreen => '作品詳細画面';

  @override
  String get promptLabel => 'Prompt:';

  @override
  String get sampleTimer => 'サンプルタイマー';
}
