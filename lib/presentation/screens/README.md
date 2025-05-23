# Screens

## 概要
このディレクトリには、アプリケーションの各画面UIコンポーネントが含まれています。

## 設計指針
- 各画面は独自のファイルに配置します
- 画面クラスはStatelessWidgetまたはStatefulWidgetを継承します
- UIの構築と表示に集中し、ビジネスロジックはBLoCに委任します
- 命名規則: `〇〇Screen`（例: `HomeScreen`, `TimerDetailScreen`）

## 主要画面
- **スプラッシュ画面**: アプリ起動時の初期画面
- **ホーム画面**: タイマー一覧の表示
- **タイマー詳細画面**: タイマーの作成・編集
- **プリセット選択画面**: キャラクターのプリセット選択
- **カスタマイズ画面**: キャラクター設定のカスタマイズ
- **設定画面**: アプリの設定
- **通知履歴画面**: 送信された通知の履歴表示
