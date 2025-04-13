import 'package:hive/hive.dart';
import 'package:tick_mate/data/datasources/local/hive_boxes.dart';

part 'migration_info_model.g.dart'; // build_runnerで生成

@HiveType(typeId: HiveBoxes.migrationInfoTypeId)
class MigrationInfoModel extends HiveObject {
  MigrationInfoModel({
    // Constructor moved to top
    required this.schemaVersion,
  });

  @HiveField(0)
  final int schemaVersion;

  @override
  String toString() => 'MigrationInfoModel(schemaVersion: $schemaVersion)';
}
