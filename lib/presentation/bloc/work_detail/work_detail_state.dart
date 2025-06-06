part of 'work_detail_bloc.dart';

abstract class WorkDetailState extends Equatable {
  const WorkDetailState();

  @override
  List<Object?> get props => [];
}

/// 初期状態
class WorkDetailInitial extends WorkDetailState {}

/// 読み込み中状態
class WorkDetailLoading extends WorkDetailState {}

/// 読み込み成功状態
class WorkDetailLoaded extends WorkDetailState {
  const WorkDetailLoaded({required this.work, required this.characters});

  final WorkEntity work;
  final List<CharacterEntity> characters;

  @override
  List<Object?> get props => [work, characters];
}

/// 読み込み失敗状態
class WorkDetailError extends WorkDetailState {
  const WorkDetailError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
