import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/data/datasources/local/local_storage_datasource.dart';
import 'package:tick_mate_t3/data/models/timer_model.dart';
import 'package:tick_mate_t3/domain/entities/timer_entity.dart';
import 'package:tick_mate_t3/domain/repositories/timer_repository.dart';

/// タイマーリポジトリの実装
@LazySingleton(as: TimerRepository)
class TimerRepositoryImpl implements TimerRepository {
  TimerRepositoryImpl(this._localStorageDataSource);
  
  final LocalStorageDataSource _localStorageDataSource;

  final LocalStorageDataSource _localStorageDataSource;

  @override
  Future<List<TimerEntity>> getAllTimers() async {
    final timerModels = _localStorageDataSource.getAllTimers();
    return timerModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<TimerEntity?> getTimerById(String id) async {
    final timerModel = _localStorageDataSource.getTimerById(id);
    return timerModel?.toEntity();
  }

  @override
  Future<List<TimerEntity>> getTimersByDateTime(DateTime dateTime) async {
    final timerModels = _localStorageDataSource.getTimersByDateTime(dateTime);
    return timerModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveTimer(TimerEntity timer) async {
    final timerModel = TimerModel.fromEntity(timer);
    await _localStorageDataSource.saveTimer(timerModel);
  }

  @override
  Future<void> deleteTimer(String id) async {
    await _localStorageDataSource.deleteTimer(id);
  }
}
