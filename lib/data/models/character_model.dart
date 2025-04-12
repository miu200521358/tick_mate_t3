import 'package:hive/hive.dart';
import 'package:tick_mate_t3/domain/entities/character_entity.dart';

part 'character_model.g.dart';

/// キャラクターモデル（Hive用）
@HiveType(typeId: 2)
class CharacterModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String workId;

  @HiveField(3)
  final String promptText;

  @HiveField(4)
  final Map<String, dynamic> parameters;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  CharacterModel({
    required this.id,
    required this.name,
    required this.workId,
    required this.promptText,
    required this.parameters,
    required this.createdAt,
    required this.updatedAt,
  });

  /// エンティティからモデルに変換
  factory CharacterModel.fromEntity(CharacterEntity entity) {
    return CharacterModel(
      id: entity.id,
      name: entity.name,
      workId: entity.workId,
      promptText: entity.promptText,
      parameters: entity.parameters,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// モデルからエンティティに変換
  CharacterEntity toEntity() {
    return CharacterEntity(
      id: id,
      name: name,
      workId: workId,
      promptText: promptText,
      parameters: parameters,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
