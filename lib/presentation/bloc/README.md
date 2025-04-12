# BLoC (Business Logic Component)

このディレクトリには、アプリケーションの状態管理に関するBLoC定義、イベント、状態が含まれています。

## 設計指針

1. **単一責任の原則**：各BLoCは特定の機能または画面の状態管理に責任を持ちます。

2. **イベント駆動**：UIからのすべての操作はイベントとして扱います。

3. **状態の不変性**：すべての状態は不変（immutable）であり、新しい状態を生成して変更を表現します。

4. **命名規則**：
   - ファイル名：`feature_bloc.dart`
   - イベント：`FeatureEvent`（基底クラス）
   - 状態：`FeatureState`（基底クラス）
   - BLoC：`FeatureBloc`

5. **ファイル構造**：
   - 各機能のBLoCは以下のファイルで構成：
     - `feature_bloc.dart`：BLoCクラスの実装
     - `feature_event.dart`：イベント定義
     - `feature_state.dart`：状態定義

## 主要BLoC

- アプリケーション全体の状態を管理する`AppBloc`
- タイマー管理のための`TimerBloc`
- キャラクター選択のための`CharacterBloc`
- 設定管理のための`SettingsBloc`
