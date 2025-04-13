import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/core/utils/dummy_data_utils.dart';
import 'package:tick_mate/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate/domain/repositories/character_repository.dart';
import 'package:tick_mate/domain/repositories/work_repository.dart';
import 'package:uuid/uuid.dart';

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

  // DIコンテナを初期化 (Generated code)
  getIt.init(environment: env);

  debugPrint('DI初期化完了: 環境[$env]');

  // Register external packages manually AFTER getIt.init()
  if (!getIt.isRegistered<ImagePicker>()) {
    getIt.registerLazySingleton<ImagePicker>(() => ImagePicker());
  }
  if (!getIt.isRegistered<Uuid>()) {
    getIt.registerLazySingleton<Uuid>(() => const Uuid());
  }

  // RetryInterceptor用の依存関係を登録
  if (!getIt.isRegistered<int>()) {
    getIt.registerFactory<int>(() => 3); // maxRetries用のデフォルト値
  }
  if (!getIt.isRegistered<Duration>()) {
    getIt.registerFactory<Duration>(
      () => const Duration(seconds: 1),
    ); // retryDelay用のデフォルト値
  }

  // DummyDataUtilsの登録（ダミーデータ用）
  if (!getIt.isRegistered<DummyDataUtils>()) {
    getIt.registerFactory<DummyDataUtils>(
      () => DummyDataUtils(
        getIt<WorkRepository>(),
        getIt<CharacterRepository>(),
        getIt<Uuid>(),
      ),
    );
  }

  // Hiveボックスを登録（既に開かれていることを前提）
  _registerHiveBoxes();
}

/// Hiveボックスを依存性注入コンテナに登録
void _registerHiveBoxes() {
  try {
    // タイプ名を付けた登録を行い、同じ型の複数のボックスを区別できるようにする

    // タイマーボックス
    getIt.registerSingleton<Box<dynamic>>(
      Hive.box(HiveBoxes.timerBox),
      instanceName: HiveBoxes.timerBox,
    );

    // キャラクターボックス
    getIt.registerSingleton<Box<dynamic>>(
      Hive.box(HiveBoxes.characterBox),
      instanceName: HiveBoxes.characterBox,
    );

    // 作品ボックス
    getIt.registerSingleton<Box<dynamic>>(
      Hive.box(HiveBoxes.workBox),
      instanceName: HiveBoxes.workBox,
    );

    // 通知履歴ボックス
    getIt.registerSingleton<Box<dynamic>>(
      Hive.box(HiveBoxes.notificationHistoryBox),
      instanceName: HiveBoxes.notificationHistoryBox,
    );

    // ユーザー設定ボックス
    getIt.registerSingleton<Box<dynamic>>(
      Hive.box(HiveBoxes.userSettingBox),
      instanceName: HiveBoxes.userSettingBox,
    );

    // サブスクリプションボックス
    getIt.registerSingleton<Box<dynamic>>(
      Hive.box(HiveBoxes.subscriptionBox),
      instanceName: HiveBoxes.subscriptionBox,
    );

    debugPrint('Hiveボックスの登録が完了しました');
  } catch (e, stackTrace) {
    debugPrint('Hiveボックスの登録に失敗しました: $e');
    debugPrint('StackTrace: $stackTrace');
    // アプリの起動に致命的ではないため、例外を再スローしない
  }
}
