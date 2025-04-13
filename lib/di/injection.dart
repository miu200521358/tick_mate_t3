import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// アプリケーション全体で使用するDIコンテナ
final GetIt getIt = GetIt.instance;

/// 環境の定義
class Env {
  static const dev = 'dev';
  static const stg = 'stg';
  static const prod = 'prod';
}

/// DIコンテナを初期化する
/// [environment] 環境名 ('dev', 'stg', 'prod') - デフォルトは開発環境
@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies([String? environment]) async {
  // 環境未指定の場合は開発環境をデフォルトとする
  final env = environment ?? (kReleaseMode ? Env.prod : Env.dev);

  // DIコンテナを初期化
  getIt.init(environment: env);
  debugPrint('DI初期化完了: 環境[$env]');
}
