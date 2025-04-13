import 'package:equatable/equatable.dart';

/// ユーザー設定エンティティ
class UserSettingEntity extends Equatable {
  const UserSettingEntity({
    required this.id,
    this.language,
    this.themeMode,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? language;
  final int? themeMode; // 0: system, 1: light, 2: dark
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, language, themeMode, createdAt, updatedAt];

  /// コピーメソッド
  UserSettingEntity copyWith({
    String? id,
    String? language,
    int? themeMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettingEntity(
      id: id ?? this.id,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
