import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/domain/entities/work_entity.dart';
import 'package:tick_mate/domain/repositories/work_repository.dart';
import 'package:tick_mate/presentation/bloc/common/bloc_error_handler.dart';

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
    await BlocErrorHandler.handle<
      List<WorkEntity>,
      WorkListBloc,
      WorkListState
    >(
      bloc: this,
      emit: emit,
      errorStateBuilder:
          (message) => WorkListError('errorLoadingWorkList', message),
      function: () async => _workRepository.getAllWorks(),
      context: event.context,
      messageKey: 'errorLoadingWorkList',
    ).then((works) {
      if (works != null) {
        emit(WorkListLoaded(works));
      }
    });
  }
}
