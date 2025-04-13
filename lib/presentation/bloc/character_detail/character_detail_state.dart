part of 'character_detail_bloc.dart';

abstract class CharacterDetailState extends Equatable {
  const CharacterDetailState();

  @override
  List<Object?> get props => [];
}

/// 初期状態
class CharacterDetailInitial extends CharacterDetailState {}

/// 読み込み中状態
class CharacterDetailLoading extends CharacterDetailState {}

/// 読み込み成功状態
class CharacterDetailLoaded extends CharacterDetailState {
  const CharacterDetailLoaded(this.character);

  final CharacterEntity character;

  @override
  List<Object?> get props => [character];
}

/// 読み込み/保存失敗状態
class CharacterDetailError extends CharacterDetailState {
  const CharacterDetailError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
