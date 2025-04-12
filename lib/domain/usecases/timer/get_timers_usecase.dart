import '../../entities/timer_entity.dart';
import '../../repositories/timer_repository.dart';

/// タイマー取得ユースケース
class GetTimersUseCase {
  final TimerRepository _timerRepository;

  GetTimersUseCase(this._timerRepository);

  /// すべてのタイマーを取得
  Future<List<TimerEntity>> execute() async {
    return await _timerRepository.getAllTimers();
  }
}
