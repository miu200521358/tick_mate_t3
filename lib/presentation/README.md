# Presentation層

## 概要
Presentation層は、ユーザーインターフェースとユーザーとのインタラクションを管理します。
主に以下の3つのコンポーネントで構成されています：

- **screens**: 各機能画面のUIコンポーネント
- **widgets**: 共通UIウィジェット
- **bloc**: BLoC定義、イベント、状態の管理

## アーキテクチャ
このアプリはClean Architectureに従い、Presentation層はDomain層に依存し、直接Data層には依存しません。
状態管理には`flutter_bloc`を使用します。

## 命名規則
- スクリーンクラス: `〇〇Screen`
- ウィジェットクラス: `〇〇Widget`
- BLoCクラス: `〇〇Bloc`
- イベントクラス: `〇〇Event`
- 状態クラス: `〇〇State`
