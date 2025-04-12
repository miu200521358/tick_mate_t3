# データ層（Data Layer）

## 概要
データ層は、ドメイン層で定義されたリポジトリインターフェースの実装を提供します。
この層は、データの永続化、API通信、キャッシュなどのデータ操作に関する具体的な実装を担当します。

## 主要コンポーネント

### モデル（Models）
- **TimerModel**: タイマーのHiveモデル
- **CharacterModel**: キャラクターのHiveモデル
- **WorkModel**: 作品のHiveモデル
- **NotificationHistoryModel**: 通知履歴のHiveモデル

### データソース（DataSources）
- **LocalStorageDataSource**: Hiveを使用したローカルストレージ操作
- **SecureStorageDataSource**: Flutter Secure Storageを使用した機密データの保存
- **GeminiApiDataSource**: Gemini APIとの通信

### リポジトリ実装（Repository Implementations）
- **TimerRepositoryImpl**: タイマーリポジトリの実装
- **CharacterRepositoryImpl**: キャラクターリポジトリの実装
- **WorkRepositoryImpl**: 作品リポジトリの実装
- **NotificationHistoryRepositoryImpl**: 通知履歴リポジトリの実装

## Hive初期化
`HiveInit`クラスは、アプリケーション起動時にHiveの初期化とボックスのオープンを行います。
タイプアダプターの登録も行い、モデルとHiveの連携を可能にします。
