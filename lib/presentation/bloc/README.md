# BLoC (Business Logic Component)

## 概要
このディレクトリには、アプリケーションの状態管理に関連するコンポーネントが含まれています。
`flutter_bloc`パッケージを使用して、イベント、状態、およびBLoCの定義を行います。

## 設計指針
- 各機能またはスクリーンに対応するBLoCを作成します
- イベント、状態、BLoCを個別のファイルに配置します
- イベントは不変（Immutable）であるべきであり、`Equatable`を継承します
- 状態も不変であり、`Equatable`を継承します
- BLoCはイベントを受け取り、状態を生成します
- 命名規則:
  - BLoC: `〇〇Bloc`（例: `HomeBloc`, `TimerBloc`）
  - イベント: `〇〇Event`（例: `HomeEvent`, `TimerCreatedEvent`）
  - 状態: `〇〇State`（例: `HomeState`, `TimerLoadingState`）

## BLoCの構成
各BLoCの実装は以下のファイル構成を持ちます：
- `〇〇_bloc.dart`: BLoCクラスの定義
- `〇〇_event.dart`: イベントクラスの定義
- `〇〇_state.dart`: 状態クラスの定義
