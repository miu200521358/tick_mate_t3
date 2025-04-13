import 'package:flutter/foundation.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tick_mate/core/error/exceptions.dart';
import 'package:tick_mate/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate/data/models/character_model.dart'; // Added
import 'package:tick_mate/data/models/migration_info_model.dart';
import 'package:tick_mate/data/models/notification_history_model.dart'; // Added
import 'package:tick_mate/data/models/subscription_model.dart'; // Added
import 'package:tick_mate/data/models/timer_model.dart'; // Added
import 'package:tick_mate/data/models/user_setting_model.dart';
import 'package:tick_mate/data/models/work_model.dart';

/// Hiveの初期化
class HiveInit {
  /// Hiveを初期化
  static Future<void> initialize() async {
    try {
      debugPrint('Hiveの初期化を開始します...');

      // Hiveの初期化
      if (kIsWeb) {
        // Web環境ではgetApplicationDocumentsDirectory()は使用できないため、
        // パスを指定せずに初期化する
        await Hive.initFlutter();
        debugPrint('Hive: Web環境で初期化しました');
      } else {
        // ネイティブ環境では通常通り初期化
        final appDocumentDir = await getApplicationDocumentsDirectory();
        await Hive.initFlutter(appDocumentDir.path);
        debugPrint('Hive: ネイティブ環境で初期化しました: ${appDocumentDir.path}');
      }

      // アダプターの登録
      await _registerAdapters();

      // ボックスを開く
      await _openBoxes();

      debugPrint('Hiveの初期化が完了しました');
    } catch (e, stackTrace) {
      final errorMsg = 'Hiveの初期化に失敗しました: $e';
      debugPrint(errorMsg);
      debugPrint('StackTrace: $stackTrace');

      // Crashlyticsにエラーを記録
      final exception = CacheException(errorMsg, stackTrace);
      await exception.recordToCrashlytics(fatal: false);

      // 例外を再スロー
      throw exception;
    }
  }

  /// Hiveアダプターの登録
  static Future<void> _registerAdapters() async {
    try {
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

      // マイグレーション情報アダプターの登録 (追加)
      if (!Hive.isAdapterRegistered(HiveBoxes.migrationInfoTypeId)) {
        Hive.registerAdapter(MigrationInfoModelAdapter());
      }

      debugPrint('Hive: すべてのアダプターを登録しました');
    } catch (e, stackTrace) {
      final errorMsg = 'Hiveアダプターの登録に失敗しました: $e';
      debugPrint(errorMsg);
      throw CacheException(errorMsg, stackTrace);
    }
  }

  /// Hiveボックスのオープン
  static Future<void> _openBoxes() async {
    try {
      // タイマーボックスのオープン
      await Hive.openBox<TimerModel>(HiveBoxes.timerBox);

      // キャラクターボックスのオープン
      await Hive.openBox<CharacterModel>(HiveBoxes.characterBox);

      // 作品ボックスのオープン
      await Hive.openBox<WorkModel>(HiveBoxes.workBox);

      // 通知履歴ボックスのオープン
      await Hive.openBox<NotificationHistoryModel>(
        HiveBoxes.notificationHistoryBox,
      );

      // ユーザー設定ボックスのオープン
      await Hive.openBox<UserSettingModel>(HiveBoxes.userSettingBox);

      // サブスクリプションボックスのオープン
      await Hive.openBox<SubscriptionModel>(HiveBoxes.subscriptionBox);

      // マイグレーション情報ボックスのオープン (追加)
      // 注意: このボックスはマイグレーションチェック前に開く必要がある
      await Hive.openBox<MigrationInfoModel>(HiveBoxes.migrationInfoBox);

      debugPrint('Hive: すべてのボックスを開きました');
    } catch (e, stackTrace) {
      final errorMsg = 'Hiveボックスのオープンに失敗しました: $e';
      debugPrint(errorMsg);
      throw CacheException(errorMsg, stackTrace);
    }
  }
}
