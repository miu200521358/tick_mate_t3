import 'package:hive/hive.dart';
import 'package:tick_mate/domain/entities/work_entity.dart';

part 'work_model.g.dart';

/// 作品モデル（Hive用）
@HiveType(typeId: 3)
class WorkModel extends HiveObject {
  WorkModel({
    required this.id,
    required this.title,
    required this.terms,
    required this.createdAt,
    required this.updatedAt,
  });

  /// エンティティからモデルに変換
  factory WorkModel.fromEntity(WorkEntity entity) {
    return WorkModel(
      id: entity.id,
      title: entity.title,
      terms: entity.terms,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final Map<String, String> terms;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  /// モデルからエンティティに変換
  WorkEntity toEntity() {
    return WorkEntity(
      id: id,
      title: title,
      terms: terms,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
