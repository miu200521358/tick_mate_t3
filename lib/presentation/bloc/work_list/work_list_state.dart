part of 'work_list_bloc.dart';

abstract class WorkListState extends Equatable {
  const WorkListState();

  @override
  List<Object> get props => [];
}

/// 初期状態
class WorkListInitial extends WorkListState {}

/// 読み込み中状態
class WorkListLoading extends WorkListState {}

/// 読み込み成功状態
class WorkListLoaded extends WorkListState {
  const WorkListLoaded(this.works);

  final List<WorkEntity> works;

  @override
  List<Object> get props => [works];
}

/// 読み込み失敗状態
class WorkListError extends WorkListState {
  const WorkListError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
