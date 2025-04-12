# Tick Mate T3

Tick Mateは、日々のタスクや習慣を簡単に記録・管理できるアプリケーションです。

## 環境設定

このプロジェクトはFlutter 3.29.2で開発されています。

### 必要条件
- Flutter 3.29.2
- Dart 3.7.2
- Android Studio / Xcode（ネイティブアプリのビルド用）

### セットアップ手順
1. Flutterをインストール: [Flutter公式サイト](https://flutter.dev/docs/get-started/install)
2. リポジトリをクローン: `git clone https://github.com/miu200521358/tick_mate_t3.git`
3. 依存関係をインストール: `flutter pub get`
4. アプリを実行: `flutter run`

## 機能
- タスク管理
- 習慣トラッキング
- 進捗状況の可視化

## 環境変数の設定

このプロジェクトでは、環境変数を使用して異なる設定を管理しています。

### 環境変数の設定方法

1. プロジェクトのルートディレクトリに `.env` ファイルを作成
2. `.env.example` ファイルを参考に必要な環境変数を設定

```
ENV=dev
BASE_URL=https://dev.api.tickmate.example.com
API_VERSION=v1
DEBUG_MODE=true
SHOW_BETA_BANNER=true
```

注意: APIキーなどのセキュリティに関わる情報は `.env` ファイルではなく、アプリの安全なストレージに保存してください。

## 開発者
- [miu200521358](https://github.com/miu200521358)
