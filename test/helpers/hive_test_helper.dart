import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:hive/hive.dart';
import 'package:tick_mate/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate/data/models/character_model.dart';
import 'package:tick_mate/data/models/migration_info_model.dart';
import 'package:tick_mate/data/models/notification_history_model.dart';
import 'package:tick_mate/data/models/subscription_model.dart';
import 'package:tick_mate/data/models/timer_model.dart';
import 'package:tick_mate/data/models/user_setting_model.dart';
import 'package:tick_mate/data/models/work_model.dart';

/// テスト用Hive環境ヘルパークラス
class HiveTestHelper {
  /// シングルトンインスタンス
  static final HiveTestHelper _instance = HiveTestHelper._internal();

  /// ファクトリーコンストラクタ
  factory HiveTestHelper() {
    return _instance;
  }

  /// 内部コンストラクタ
  HiveTestHelper._internal();

  /// 一時ディレクトリパス
  Directory? _tempDir;

  /// 初期化済みフラグ
  bool _initialized = false;

  /// Hiveテスト環境を初期化
  Future<void> setUp() async {
    // 既に初期化されている場合は一度クリーンアップする
    if (_initialized) {
      await tearDown();
    }

    try {
      // 一時ディレクトリを作成
      _tempDir = await Directory.systemTemp.createTemp('hive_test_');
      debugPrint('テスト用Hiveディレクトリを作成しました: ${_tempDir!.path}');

      // Hiveの初期化
      Hive.init(_tempDir!.path);
      debugPrint('Hiveを初期化しました: ${_tempDir!.path}');

      // アダプターの登録
      await _registerAdapters();

      // ボックスを開く
      await _openBoxes();

      _initialized = true;
      debugPrint('Hiveテスト環境のセットアップが完了しました');
    } catch (e, stackTrace) {
      debugPrint('Hiveテスト環境のセットアップに失敗しました: $e');
      debugPrint('StackTrace: $stackTrace');
      rethrow;
    }
  }

  /// Hiveアダプターの登録
  Future<void> _registerAdapters() async {
    // タイマーアダプターの登録
    if (!Hive.isAdapterRegistered(HiveBoxes.timerTypeId)) {
      Hive.registerAdapter(TimerModelAdapter());
    }

    // キャラクターアダプターの登録
    if (!Hive.isAdapterRegistered(HiveBoxes.characterTypeId)) {
      Hive.registerAdapter(CharacterModelAdapter());
    }

    // 作品アダプターの登録
    if (!Hive.isAdapterRegistered(HiveBoxes.workTypeId)) {
      Hive.registerAdapter(WorkModelAdapter());
    }

    // 通知履歴アダプターの登録
    if (!Hive.isAdapterRegistered(HiveBoxes.notificationHistoryTypeId)) {
      Hive.registerAdapter(NotificationHistoryModelAdapter());
    }

    // ユーザー設定アダプターの登録
    if (!Hive.isAdapterRegistered(HiveBoxes.userSettingTypeId)) {
      Hive.registerAdapter(UserSettingModelAdapter());
    }

    // サブスクリプションアダプターの登録
    if (!Hive.isAdapterRegistered(HiveBoxes.subscriptionTypeId)) {
      Hive.registerAdapter(SubscriptionModelAdapter());
    }

    // マイグレーション情報アダプターの登録
    if (!Hive.isAdapterRegistered(HiveBoxes.migrationInfoTypeId)) {
      Hive.registerAdapter(MigrationInfoModelAdapter());
    }

    debugPrint('すべてのアダプターを登録しました');
  }

  /// Hiveボックスのオープン
  Future<void> _openBoxes() async {
    await Hive.openBox<TimerModel>(HiveBoxes.timerBox);
    await Hive.openBox<CharacterModel>(HiveBoxes.characterBox);
    await Hive.openBox<WorkModel>(HiveBoxes.workBox);
    await Hive.openBox<NotificationHistoryModel>(
      HiveBoxes.notificationHistoryBox,
    );
    await Hive.openBox<UserSettingModel>(HiveBoxes.userSettingBox);
    await Hive.openBox<SubscriptionModel>(HiveBoxes.subscriptionBox);
    await Hive.openBox<MigrationInfoModel>(HiveBoxes.migrationInfoBox);

    debugPrint('すべてのボックスを開きました');
  }

  /// Hiveテスト環境をクリーンアップ
  Future<void> tearDown() async {
    if (!_initialized) return;

    try {
      // すべてのボックスを閉じる
      await Hive.close();

      // 一時ディレクトリを削除
      if (_tempDir != null && _tempDir!.existsSync()) {
        await _tempDir!.delete(recursive: true);
      }

      _initialized = false;
      debugPrint('Hiveテスト環境をクリーンアップしました');
    } catch (e) {
      debugPrint('Hiveテスト環境のクリーンアップに失敗しました: $e');
    }
  }

  /// テストケース用のセットアップとティアダウンを登録
  void setUpTestCase() {
    flutter_test.setUp(() async {
      await HiveTestHelper().setUp();
    });

    flutter_test.tearDown(() async {
      await HiveTestHelper().tearDown();
    });
  }
}
