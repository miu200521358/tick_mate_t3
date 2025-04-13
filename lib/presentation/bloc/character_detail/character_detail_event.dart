part of 'character_detail_bloc.dart';

abstract class CharacterDetailEvent extends Equatable {
  const CharacterDetailEvent();

  @override
  List<Object?> get props => [];
}

/// イベント：キャラクター詳細の読み込み要求
class LoadCharacterDetail extends CharacterDetailEvent {
  final String characterId;

  const LoadCharacterDetail(this.characterId);

  @override
  List<Object> get props => [characterId];
}

/// イベント：キャラクター画像の選択・保存要求
class PickAndSaveCharacterImage extends CharacterDetailEvent {
  final ImageSource source;

  const PickAndSaveCharacterImage(this.source);

  @override
  List<Object> get props => [source];
}
