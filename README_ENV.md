# 環境ごとのFirebase設定

このプロジェクトでは、開発(dev)、ステージング(stg)、本番(prod)の3つの環境に対応するための設定が実装されています。

## 設定ファイル

環境ごとに以下のファイルが用意されています：

1. `.env.dev` - 開発環境用の設定
2. `.env.stg` - ステージング環境用の設定
3. `.env.prod` - 本番環境用の設定

各環境設定ファイルには、以下の情報が含まれています：
- 環境識別子 (ENV)
- API基本URL
- APIバージョン
- デバッグモードフラグ
- ベータバナー表示フラグ
- Firebase設定（APIキー、アプリID、プロジェクトIDなど）

## セキュリティについて

セキュリティ上の理由から、以下のファイルはGitリポジトリに含めないようにしてください：

- `.env.*` ファイル（環境変数ファイル）
- `google-services.json` ファイル（Firebase設定ファイル）

これらのファイルはチーム内で安全に共有するか、CI/CD環境で自動的に生成するようにしてください。

## 使い方

### ビルドと実行

環境ごとのビルドと実行は、以下のスクリプトを使用します：

#### ビルド

```bash
# 開発環境用
scripts\build_android.bat dev

# ステージング環境用
scripts\build_android.bat stg

# 本番環境用
scripts\build_android.bat prod
```

#### 実行（デバッグモード）

```bash
# 開発環境用
scripts\run_android.bat dev

# ステージング環境用
scripts\run_android.bat stg

# 本番環境用
scripts\run_android.bat prod
```

#### VSCodeからの実行

VSCodeから実行する場合は、launch.jsonに適切な設定が必要です。
現在の設定では、開発環境（dev）用の設定が組み込まれています：

```json
{
    "name": "tick_mate",
    "request": "launch",
    "type": "dart",
    "flutterMode": "debug",
    "args": [
        "--flavor",
        "dev",
        "--dart-define=FLAVOR=dev"
    ]
}
```

他の環境で実行したい場合は、この設定をコピーして環境名を変更してください。

### 新しい環境の追加方法

1. 新しい環境用の `.env.[環境名]` ファイルを作成
2. Firebase Consoleで新しいアプリを登録
3. 取得した `google-services.json` を `android/app/src/[環境名]/` に配置
4. `android/app/build.gradle.kts` に新しい環境用のFlavor設定を追加
5. スクリプトファイルに新しい環境用の処理を追加

## 環境変数の使い方

アプリ内で環境変数を使用する場合は、以下のようにします：

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 環境変数を取得
final apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';
final baseUrl = dotenv.env['BASE_URL'] ?? 'https://default-api.example.com';
```

## 重要な設定ファイル

### pubspec.yaml

アセット設定に環境設定ファイルを登録する必要があります：

```yaml
assets:
  - .env
  - .env.dev
  - .env.stg
  - .env.prod
```

この設定がないと、Flutterは環境設定ファイルを見つけることができません。

### Firebase設定について

Firebase設定は `lib/firebase_options.dart` で環境変数から動的に読み込まれます。
各環境用のGoogle Servicesファイルは `android/app/src/[環境名]/google-services.json` に配置してください。

## トラブルシューティング

環境設定ファイルが読み込めない場合は、以下を確認してください：

1. pubspec.yamlに正しいアセットパスが登録されているか
2. 実行時に正しい`--flavor`と`--dart-define=FLAVOR=環境名`が指定されているか
3. 環境設定ファイル（.env.dev など）が正しい場所に存在するか
