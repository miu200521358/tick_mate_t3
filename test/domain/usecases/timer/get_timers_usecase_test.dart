import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate/data/datasources/local/local_storage_datasource.dart';
import 'package:tick_mate/data/repositories/timer_repository_impl.dart';
import 'package:tick_mate/domain/entities/timer_entity.dart';
import 'package:tick_mate/domain/usecases/timer/get_timers_usecase.dart';

import '../../../helpers/hive_test_helper.dart';

void main() {
  late HiveTestHelper hiveTestHelper;
  late LocalStorageDataSource localStorageDataSource;
  late TimerRepositoryImpl timerRepository;
  late GetTimersUseCase getTimersUseCase;

  // テスト用データ
  final testDateTime = DateTime(2023, 1, 1, 10, 0);
  final testTimer1 = TimerEntity(
    id: 'test_timer_1',
    title: 'テストタイマー1',
    timeSpecificationType: TimeSpecificationType.dateTime, // <<< 追加
    dateTime: testDateTime,
    timeRange: '10:00-11:00',
    timerType: TimerType.schedule,
    repeatType: RepeatType.none,
    characterIds: ['test_character_1'],
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  final testTimer2 = TimerEntity(
    id: 'test_timer_2',
    title: 'テストタイマー2',
    timeSpecificationType: TimeSpecificationType.dateTime, // <<< 追加
    dateTime: testDateTime.add(const Duration(days: 1)),
    timeRange: '13:00-14:00',
    timerType: TimerType.status,
    repeatType: RepeatType.daily,
    characterIds: ['test_character_2'],
    createdAt: testDateTime,
    updatedAt: testDateTime,
  );

  // 各テストの前に実行
  setUp(() async {
    // Hiveテスト環境をセットアップ
    hiveTestHelper = HiveTestHelper();
    await hiveTestHelper.setUp();

    // テスト対象のインスタンスを作成
    localStorageDataSource = LocalStorageDataSource();
    timerRepository = TimerRepositoryImpl(localStorageDataSource);
    getTimersUseCase = GetTimersUseCase(timerRepository);

    // テストデータを保存
    await timerRepository.saveTimer(testTimer1);
    await timerRepository.saveTimer(testTimer2);
  });

  // 各テストの後に実行
  tearDown(() async {
    // Hiveテスト環境をクリーンアップ
    await hiveTestHelper.tearDown();
  });

  group('GetTimersUseCase', () {
    test('すべてのタイマーを取得できること', () async {
      // ユースケースを実行
      final timers = await getTimersUseCase.execute();

      // 検証
      expect(timers.length, 2);
      expect(
        timers.map((e) => e.id).toList()..sort(),
        [testTimer1.id, testTimer2.id]..sort(),
      );
    });
  });
}
