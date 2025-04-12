import '../entities/character_entity.dart';

/// キャラクターリポジトリインターフェース
abstract class CharacterRepository {
  /// すべてのキャラクターを取得
  Future<List<CharacterEntity>> getAllCharacters();

  /// 作品IDでキャラクターを取得
  Future<List<CharacterEntity>> getCharactersByWorkId(String workId);

  /// IDでキャラクターを取得
  Future<CharacterEntity?> getCharacterById(String id);

  /// 複数のIDでキャラクターを取得
  Future<List<CharacterEntity>> getCharactersByIds(List<String> ids);

  /// キャラクターを保存
  Future<void> saveCharacter(CharacterEntity character);

  /// キャラクターを削除
  Future<void> deleteCharacter(String id);
}
