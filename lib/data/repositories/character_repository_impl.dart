import 'package:injectable/injectable.dart';
import 'package:tick_mate/data/datasources/local/local_storage_datasource.dart';
import 'package:tick_mate/data/models/character_model.dart';
import 'package:tick_mate/domain/entities/character_entity.dart';
import 'package:tick_mate/domain/repositories/character_repository.dart';

/// キャラクターリポジトリの実装
@LazySingleton(as: CharacterRepository)
class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl(this._localStorageDataSource);

  final LocalStorageDataSource _localStorageDataSource;

  @override
  Future<List<CharacterEntity>> getAllCharacters() async {
    final characterModels = _localStorageDataSource.getAllCharacters();
    return characterModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<CharacterEntity>> getCharactersByWorkId(String workId) async {
    final characterModels = _localStorageDataSource.getCharactersByWorkId(
      workId,
    );
    return characterModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<CharacterEntity?> getCharacterById(String id) async {
    final characterModel = _localStorageDataSource.getCharacterById(id);
    return characterModel?.toEntity();
  }

  @override
  Future<List<CharacterEntity>> getCharactersByIds(List<String> ids) async {
    final characterModels = _localStorageDataSource.getCharactersByIds(ids);
    return characterModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveCharacter(CharacterEntity character) async {
    final characterModel = CharacterModel.fromEntity(character);
    await _localStorageDataSource.saveCharacter(characterModel);
  }

  @override
  Future<void> deleteCharacter(String id) async {
    await _localStorageDataSource.deleteCharacter(id);
  }
}
