import 'package:equatable/equatable.dart';

/// キャラクターエンティティ
class CharacterEntity extends Equatable {
  const CharacterEntity({
    required this.id,
    required this.name,
    required this.workId,
    required this.promptText,
    required this.parameters,
    required this.createdAt,
    required this.updatedAt,
    this.imagePath, // Renamed from imageUrl
  });

  @override
  List<Object?> get props => [
    id,
    name,
    workId,
    promptText,
    parameters,
    createdAt,
    updatedAt,
    imagePath, // Renamed from imageUrl
  ];

  final String id;
  final String name;
  final String workId;
  final String promptText;
  final Map<String, dynamic> parameters;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imagePath; // Renamed from imageUrl

  /// 新しいキャラクターエンティティを作成
  CharacterEntity copyWith({
    String? id,
    String? name,
    String? workId,
    String? promptText,
    Map<String, dynamic>? parameters,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imagePath, // Renamed from imageUrl
  }) {
    return CharacterEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      workId: workId ?? this.workId,
      promptText: promptText ?? this.promptText,
      parameters: parameters ?? this.parameters,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imagePath: imagePath ?? this.imagePath, // Renamed from imageUrl
    );
  }
}
