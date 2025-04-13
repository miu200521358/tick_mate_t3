part of 'character_detail_bloc.dart';

abstract class CharacterDetailEvent extends Equatable {
  const CharacterDetailEvent();

  @override
  List<Object?> get props => [];
}

/// イベント：キャラクター詳細の読み込み要求
class LoadCharacterDetail extends CharacterDetailEvent {
  const LoadCharacterDetail(this.characterId);

  final String characterId;

  @override
  List<Object> get props => [characterId];
}

/// イベント：キャラクター画像の選択・保存要求
class PickAndSaveCharacterImage extends CharacterDetailEvent {
  const PickAndSaveCharacterImage(this.source);

  final ImageSource source;

  @override
  List<Object> get props => [source];
}
