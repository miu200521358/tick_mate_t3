# Widgets

## 概要
このディレクトリには、アプリケーション全体で再利用可能な共通UIウィジェットが含まれています。

## 設計指針
- ウィジェットは単一責任の原則に従い、特定の目的に焦点を当てます
- 再利用性と柔軟性を重視します
- カスタマイズ可能なパラメータを提供します
- 命名規則: `〇〇Widget`（例: `TimerCardWidget`, `CharacterAvatarWidget`）

## 共通ウィジェット例
- **TimerCardWidget**: タイマー情報を表示するカード
- **CharacterSelectorWidget**: キャラクター選択用ウィジェット
- **NotificationItemWidget**: 通知履歴の項目
- **CustomButtonWidget**: アプリ全体で使用される共通ボタン
