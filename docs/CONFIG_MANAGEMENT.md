# 設定管理ガイド

このドキュメントでは、アプリケーションの設定と環境変数の管理方法について説明します。

## 設定の種類

アプリケーションでは、以下の3種類の設定管理方法を使用しています：

1. **AppConfig** - 環境依存の設定値（開発環境、ステージング環境、本番環境で異なる値）
2. **AppConstants** - 環境に依存しない固定値
3. **SecureStorage** - APIキーなどの機密情報

## 命名規則

### 環境変数

環境変数の命名規則は以下の通りです：

- 大文字のスネークケース（例：`API_VERSION`、`DEBUG_MODE`）
- 単語は明確で具体的に（`SIZE` ではなく `IMAGE_SIZE_KB` など）
- キーの定義は `AppConstants` クラスに配置

### 設定値

アプリケーション内の設定値の命名規則：

- `AppConfig` のgetterはキャメルケース（例：`baseUrl`、`isDebugMode`）
- 定数は大文字のスネークケース（例：`DEFAULT_PAGE_SIZE`）
- 意味が明確な名前を使用する

## 設定の更新方法

設定を更新する際は、以下の手順に従ってください：

1. 環境依存の設定は `AppConfig` クラスとその実装クラスを更新
2. 固定値の定数は `AppConstants` クラスに追加
3. 環境変数を追加した場合は `.env.example` ファイルも更新
4. セキュアな値は `SecureStorageDataSource` を使用して保存・取得

## dart-define による設定

ビルド時に環境を指定するには、以下のようにdart-defineを使用します：

```bash
flutter run --dart-define=ENV=prod
```

または、特定の設定値のみを上書きする場合：

```bash
flutter run --dart-define=BASE_URL=https://custom-api.example.com
```

## 環境ファイル

環境ごとのデフォルト設定は、以下のファイルで管理されています：

- 開発環境: `.env.dev`
- ステージング環境: `.env.stg`
- 本番環境: `.env.prod`

基本設定は `.env` ファイルに記述し、環境固有の設定はそれぞれの環境ファイルに記述します。

## セキュリティに関する注意

- APIキーなどの機密情報は、環境ファイルではなく `SecureStorageDataSource` を使用して管理してください。
- Gitリポジトリには `.env.example` のみをコミットし、実際の環境ファイル（`.env`、`.env.dev` など）はコミットしないでください。
