import 'package:tick_mate_t3/data/datasources/local/local_storage_datasource.dart';
import 'package:tick_mate_t3/data/models/work_model.dart';
import 'package:tick_mate_t3/domain/entities/work_entity.dart';
import 'package:tick_mate_t3/domain/repositories/work_repository.dart';

/// 作品リポジトリの実装
class WorkRepositoryImpl implements WorkRepository {
  final LocalStorageDataSource _localStorageDataSource;

  WorkRepositoryImpl({LocalStorageDataSource? localStorageDataSource})
    : _localStorageDataSource =
          localStorageDataSource ?? LocalStorageDataSource();

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
