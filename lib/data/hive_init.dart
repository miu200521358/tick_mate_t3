import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tick_mate_t3/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate_t3/data/models/character_model.dart';
import 'package:tick_mate_t3/data/models/notification_history_model.dart';
import 'package:tick_mate_t3/data/models/timer_model.dart';
import 'package:tick_mate_t3/data/models/work_model.dart';

/// Hiveの初期化
class HiveInit {
  /// Hiveを初期化
  static Future<void> initialize() async {
    // Hiveの初期化
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // アダプターの登録
    Hive.registerAdapter(TimerModelAdapter());
    Hive.registerAdapter(CharacterModelAdapter());
    Hive.registerAdapter(WorkModelAdapter());
    Hive.registerAdapter(NotificationHistoryModelAdapter());

    // ボックスを開く
    await Hive.openBox<TimerModel>(HiveBoxes.timerBox);
    await Hive.openBox<CharacterModel>(HiveBoxes.characterBox);
    await Hive.openBox<WorkModel>(HiveBoxes.workBox);
    await Hive.openBox<NotificationHistoryModel>(
      HiveBoxes.notificationHistoryBox,
    );
  }
}
