import 'dart:math';

import 'package:injectable/injectable.dart';
import '../../entities/character_entity.dart';
import '../../repositories/character_repository.dart';

/// キャラクター選出ユースケース
@injectable
class SelectCharacterUseCase {
  SelectCharacterUseCase(this._characterRepository, this._random);

  final CharacterRepository _characterRepository;
  final Random _random;

  /// タイマー用のキャラクターをランダムに1人選出
  Future<CharacterEntity> execute(List<String> characterIds) async {
    if (characterIds.isEmpty) {
      throw ArgumentError('キャラクターIDリストが空です');
    }

    // キャラクターリストを取得
    final characters = await _characterRepository.getCharactersByIds(
      characterIds,
    );

    if (characters.isEmpty) {
      throw Exception('有効なキャラクターが見つかりませんでした');
    }

    // ランダムに1人選出
    final randomIndex = _random.nextInt(characters.length);
    return characters[randomIndex];
  }
}
