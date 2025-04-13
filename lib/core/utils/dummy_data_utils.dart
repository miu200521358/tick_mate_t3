import 'package:injectable/injectable.dart';
import 'package:tick_mate/domain/entities/character_entity.dart';
import 'package:tick_mate/domain/entities/work_entity.dart';
import 'package:tick_mate/domain/repositories/character_repository.dart';
import 'package:tick_mate/domain/repositories/work_repository.dart';
import 'package:uuid/uuid.dart';

/// ダミーデータユーティリティクラス
@injectable
class DummyDataUtils {
  DummyDataUtils(this._workRepository, this._characterRepository, this._uuid);

  final WorkRepository _workRepository;
  final CharacterRepository _characterRepository;
  final Uuid _uuid;

  /// ダミーデータを作成
  Future<void> createDummyData() async {
    final now = DateTime.now();

    // 作品1: 鬼滅の刃
    final workId1 = _uuid.v4();
    final work1 = WorkEntity(
      id: workId1,
      title: '鬼滅の刃',
      terms: {'呼吸': '剣士が使う特殊な呼吸法', '鬼': '人を食べる怪物', '鬼殺隊': '鬼を倒すための組織'},
      createdAt: now,
      updatedAt: now,
    );

    // 作品2: 進撃の巨人
    final workId2 = _uuid.v4();
    final work2 = WorkEntity(
      id: workId2,
      title: '進撃の巨人',
      terms: {
        '巨人': '人間を捕食する巨大な人型生物',
        '立体機動装置': '高所を移動するための装置',
        'ウォール': '人類を守る巨大な壁',
      },
      createdAt: now,
      updatedAt: now,
    );

    // 作品3: ワンピース
    final workId3 = _uuid.v4();
    final work3 = WorkEntity(
      id: workId3,
      title: 'ワンピース',
      terms: {
        '海賊': '海を渡り冒険する者',
        '悪魔の実': '食べると特殊な能力を得られる果実',
        'ワンピース': '伝説の海賊王の財宝',
      },
      createdAt: now,
      updatedAt: now,
    );

    // 作品を保存
    await _workRepository.saveWork(work1);
    await _workRepository.saveWork(work2);
    await _workRepository.saveWork(work3);

    // 作品1のキャラクター
    final char1 = CharacterEntity(
      id: _uuid.v4(),
      name: '竈門炭治郎',
      workId: workId1,
      promptText: '鬼殺隊の剣士で、水の呼吸の使い手。妹を人間に戻すために鬼と戦っている。',
      parameters: {
        'personality': '優しく、強い正義感を持つ',
        'ability': '水の呼吸',
        'role': '主人公',
      },
      createdAt: now,
      updatedAt: now,
    );

    final char2 = CharacterEntity(
      id: _uuid.v4(),
      name: '竈門禰豆子',
      workId: workId1,
      promptText: '炭治郎の妹で、鬼になったが人間の心を持ち続けている。',
      parameters: {'personality': '優しく、兄想い', 'ability': '爆血', 'role': 'ヒロイン'},
      createdAt: now,
      updatedAt: now,
    );

    // 作品2のキャラクター
    final char3 = CharacterEntity(
      id: _uuid.v4(),
      name: 'エレン・イェーガー',
      workId: workId2,
      promptText: '主人公で、巨人の力を持つ少年。',
      parameters: {
        'personality': '自由を求め、復讐心が強い',
        'ability': '巨人化',
        'role': '主人公',
      },
      createdAt: now,
      updatedAt: now,
    );

    final char4 = CharacterEntity(
      id: _uuid.v4(),
      name: 'ミカサ・アッカーマン',
      workId: workId2,
      promptText: 'エレンの幼なじみで、戦闘能力が高い。',
      parameters: {
        'personality': '冷静で、エレンを守ることに執着',
        'ability': '優れた身体能力',
        'role': 'ヒロイン',
      },
      createdAt: now,
      updatedAt: now,
    );

    // 作品3のキャラクター
    final char5 = CharacterEntity(
      id: _uuid.v4(),
      name: 'モンキー・D・ルフィ',
      workId: workId3,
      promptText: '海賊王を目指す少年で、ゴムゴムの実の能力者。',
      parameters: {
        'personality': '単純明快で、仲間思い',
        'ability': 'ゴムゴムの実',
        'role': '主人公',
      },
      createdAt: now,
      updatedAt: now,
    );

    final char6 = CharacterEntity(
      id: _uuid.v4(),
      name: 'ゾロ',
      workId: workId3,
      promptText: 'ルフィの仲間で、三刀流の剣士。',
      parameters: {
        'personality': '真面目で、夢に向かって努力する',
        'ability': '三刀流',
        'role': '副主人公',
      },
      createdAt: now,
      updatedAt: now,
    );

    // キャラクターを保存
    await _characterRepository.saveCharacter(char1);
    await _characterRepository.saveCharacter(char2);
    await _characterRepository.saveCharacter(char3);
    await _characterRepository.saveCharacter(char4);
    await _characterRepository.saveCharacter(char5);
    await _characterRepository.saveCharacter(char6);
  }
}
