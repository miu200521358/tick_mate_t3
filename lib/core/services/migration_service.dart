import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:tick_mate/core/constants/app_constants.dart';
import 'package:tick_mate/data/models/migration_info_model.dart';

/// Hiveデータベースのスキーママイグレーションを管理するサービスクラス
class MigrationService {
  MigrationService(this._migrationInfoBox); // Constructor moved to top

  final Box<MigrationInfoModel> _migrationInfoBox;

  /// 現在のデータベーススキーマバージョンを取得
  int get currentStoredVersion {
    // ボックスが空か、キーが存在しない場合はバージョン0とする
    if (_migrationInfoBox.isEmpty || !_migrationInfoBox.containsKey(0)) {
      return 0;
    }
    // キー0に保存されているバージョン情報を取得
    return _migrationInfoBox.get(0)?.schemaVersion ?? 0;
  }

  /// データベースマイグレーションを実行
  Future<void> runMigrations() async {
    final storedVersion = currentStoredVersion;
    final targetVersion = AppConstants.currentDbSchemaVersion;

    debugPrint(
      'Migration Check: Stored Version=$storedVersion, Target Version=$targetVersion',
    );

    if (storedVersion < targetVersion) {
      debugPrint('Migration Required: Running migrations...');
      // --- マイグレーションステップ ---
      // storedVersionに応じて、必要なマイグレーション処理をここに追加していく
      // 例: if (storedVersion < 1) { await _migrateToVersion1(); }
      // 例: if (storedVersion < 2) { await _migrateToVersion2(); }

      // 現状はバージョン1へのマイグレーションのみ（初期化）
      if (storedVersion < 1) {
        // バージョン1へのマイグレーション処理（今回は特に何もしないが、将来追加）
        debugPrint('Migrating to version 1...');
        // await _migrateToVersion1(); // 将来的なマイグレーション関数呼び出し
      }

      // --- マイグレーション完了後 ---
      // 新しいバージョン情報を保存
      await _updateSchemaVersion(targetVersion);
      debugPrint(
        'Migration Completed: Schema version updated to $targetVersion',
      );
    } else if (storedVersion > targetVersion) {
      // ダウングレードは基本的にサポートしないが、ログは残す
      debugPrint(
        'Migration Warning: Stored version ($storedVersion) is newer than target version ($targetVersion). Downgrade is not supported.',
      );
      // 必要であればエラーハンドリングやデータ削除処理を追加
    } else {
      debugPrint('Migration Not Required: Schema version is up-to-date.');
    }
  }

  /// スキーマバージョン情報を更新
  Future<void> _updateSchemaVersion(int newVersion) async {
    final migrationInfo = MigrationInfoModel(schemaVersion: newVersion);
    // キー0にバージョン情報を保存（常に上書き）
    await _migrationInfoBox.put(0, migrationInfo);
  }

  // --- 将来のマイグレーション関数 ---
  // 例:
  // Future<void> _migrateToVersion1() async {
  //   // version 0 -> 1 のマイグレーション処理
  // }
  // Future<void> _migrateToVersion2() async {
  //   // version 1 -> 2 のマイグレーション処理
  // }
}
