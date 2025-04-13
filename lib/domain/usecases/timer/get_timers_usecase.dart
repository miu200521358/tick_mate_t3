import 'package:injectable/injectable.dart';
import '../../entities/timer_entity.dart';
import '../../repositories/timer_repository.dart';

/// タイマー取得ユースケース
@injectable
class GetTimersUseCase {
  GetTimersUseCase(this._timerRepository);

  final TimerRepository _timerRepository;

  /// すべてのタイマーを取得
  Future<List<TimerEntity>> execute() async {
    return await _timerRepository.getAllTimers();
  }
}
