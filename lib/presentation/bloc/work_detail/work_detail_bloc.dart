import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/domain/entities/character_entity.dart';
import 'package:tick_mate/domain/entities/work_entity.dart';
import 'package:tick_mate/domain/repositories/character_repository.dart';
import 'package:tick_mate/domain/repositories/work_repository.dart';

part 'work_detail_event.dart';
part 'work_detail_state.dart';

@injectable
class WorkDetailBloc extends Bloc<WorkDetailEvent, WorkDetailState> {
  WorkDetailBloc(this._workRepository, this._characterRepository)
      : super(WorkDetailInitial()) {
    on<LoadWorkDetail>(_onLoadWorkDetail);
  }

  final WorkRepository _workRepository;
  final CharacterRepository _characterRepository;

  Future<void> _onLoadWorkDetail(
    LoadWorkDetail event,
    Emitter<WorkDetailState> emit,
  ) async {
    emit(WorkDetailLoading());
    try {
      final work = await _workRepository.getWorkById(event.workId);
      if (work == null) {
        emit(const WorkDetailError('指定された作品が見つかりません。'));
        return;
      }
      // workIdでキャラクターを取得
      final characters = await _characterRepository.getCharactersByWorkId(
        event.workId,
      );

      emit(WorkDetailLoaded(work: work, characters: characters));
    } catch (e) {
      // TODO: エラーハンドリングを改善
      emit(WorkDetailError('作品詳細の読み込みに失敗しました: $e'));
    }
  }
}
