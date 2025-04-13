import 'package:injectable/injectable.dart';
import 'package:tick_mate/data/datasources/local/local_storage_datasource.dart';
import 'package:tick_mate/data/models/work_model.dart';
import 'package:tick_mate/domain/entities/work_entity.dart';
import 'package:tick_mate/domain/repositories/work_repository.dart';

/// 作品リポジトリの実装
@LazySingleton(as: WorkRepository)
class WorkRepositoryImpl implements WorkRepository {
  WorkRepositoryImpl(this._localStorageDataSource);

  final LocalStorageDataSource _localStorageDataSource;

  @override
  Future<List<WorkEntity>> getAllWorks() async {
    final workModels = _localStorageDataSource.getAllWorks();
    return workModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<WorkEntity?> getWorkById(String id) async {
    final workModel = _localStorageDataSource.getWorkById(id);
    return workModel?.toEntity();
  }

  @override
  Future<void> saveWork(WorkEntity work) async {
    final workModel = WorkModel.fromEntity(work);
    await _localStorageDataSource.saveWork(workModel);
  }

  @override
  Future<void> deleteWork(String id) async {
    await _localStorageDataSource.deleteWork(id);
  }
}
