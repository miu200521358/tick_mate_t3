import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tick_mate/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate/data/models/character_model.dart';
import 'package:tick_mate/data/models/notification_history_model.dart';
import 'package:tick_mate/data/models/subscription_model.dart';
import 'package:tick_mate/data/models/timer_model.dart';
import 'package:tick_mate/data/models/user_setting_model.dart';
import 'package:tick_mate/data/models/work_model.dart';

/// Hiveの初期化
class HiveInit {
  /// Hiveを初期化
  static Future<void> initialize() async {
    // Hiveの初期化
    if (kIsWeb) {
      // Web環境ではgetApplicationDocumentsDirectory()は使用できないため、
      // パスを指定せずに初期化する
      await Hive.initFlutter();
    } else {
      // ネイティブ環境では通常通り初期化
      final appDocumentDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDir.path);
    }

    // アダプターの登録
    await _registerAdapters();

    // ボックスを開く
    await _openBoxes();
  }

  /// Hiveアダプターの登録
  static Future<void> _registerAdapters() async {
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
  }

  /// Hiveボックスのオープン
  static Future<void> _openBoxes() async {
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
  }
}
