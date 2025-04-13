import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/domain/entities/work_entity.dart';
import 'package:tick_mate/domain/repositories/work_repository.dart';

part 'work_list_event.dart';
part 'work_list_state.dart';

@injectable
class WorkListBloc extends Bloc<WorkListEvent, WorkListState> {
  WorkListBloc(this._workRepository) : super(WorkListInitial()) {
    on<LoadWorkList>(_onLoadWorkList);
  }

  final WorkRepository _workRepository;

  Future<void> _onLoadWorkList(
    LoadWorkList event,
    Emitter<WorkListState> emit,
  ) async {
    emit(WorkListLoading());
    try {
      final works = await _workRepository.getAllWorks();
      emit(WorkListLoaded(works));
    } catch (e) {
      // TODO: エラーハンドリングを改善
      emit(WorkListError('作品リストの読み込みに失敗しました: $e'));
    }
  }
}
