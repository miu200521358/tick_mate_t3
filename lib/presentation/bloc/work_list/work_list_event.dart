part of 'work_list_bloc.dart';

abstract class WorkListEvent extends Equatable {
  const WorkListEvent();

  @override
  List<Object> get props => [];
}

/// イベント：作品リストの読み込み要求
class LoadWorkList extends WorkListEvent {
  const LoadWorkList({this.context});

  final BuildContext? context;

  @override
  List<Object> get props => [context].whereType<Object>().toList();
}
