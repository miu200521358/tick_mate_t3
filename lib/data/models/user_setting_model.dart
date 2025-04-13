import 'package:hive/hive.dart';
import 'package:tick_mate/domain/entities/user_setting_entity.dart';

part 'user_setting_model.g.dart';

/// ユーザー設定モデル（Hive用）
@HiveType(typeId: 6)
class UserSettingModel extends HiveObject {
  UserSettingModel({
    required this.id,
    this.language,
    this.themeMode,
    required this.createdAt,
    required this.updatedAt,
  });

  /// エンティティからモデルに変換
  factory UserSettingModel.fromEntity(UserSettingEntity entity) {
    return UserSettingModel(
      id: entity.id,
      language: entity.language,
      themeMode: entity.themeMode,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? language;

  @HiveField(2)
  final int? themeMode;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  /// モデルからエンティティに変換
  UserSettingEntity toEntity() {
    return UserSettingEntity(
      id: id,
      language: language,
      themeMode: themeMode,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
