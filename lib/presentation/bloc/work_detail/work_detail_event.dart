part of 'work_detail_bloc.dart';

abstract class WorkDetailEvent extends Equatable {
  const WorkDetailEvent();

  @override
  List<Object> get props => [];
}

/// イベント：作品詳細とキャラクターリストの読み込み要求
class LoadWorkDetail extends WorkDetailEvent {
  final String workId;

  const LoadWorkDetail(this.workId);

  @override
  List<Object> get props => [workId];
}
