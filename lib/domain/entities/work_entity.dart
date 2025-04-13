import 'package:equatable/equatable.dart';

/// 作品エンティティ
class WorkEntity extends Equatable {
  const WorkEntity({
    required this.id,
    required this.title,
    required this.terms,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final Map<String, String> terms;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, title, terms, createdAt, updatedAt];

  /// 新しい作品エンティティを作成
  WorkEntity copyWith({
    String? id,
    String? title,
    Map<String, String>? terms,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      terms: terms ?? this.terms,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
