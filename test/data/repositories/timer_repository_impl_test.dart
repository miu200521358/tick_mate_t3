import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate/data/datasources/local/local_storage_datasource.dart';
import 'package:tick_mate/data/repositories/timer_repository_impl.dart';
import 'package:tick_mate/domain/entities/timer_entity.dart';

import '../../helpers/hive_test_helper.dart';

void main() {
  late HiveTestHelper hiveTestHelper;
  late LocalStorageDataSource localStorageDataSource;
  late TimerRepositoryImpl timerRepository;

  // テスト用データ
  final testDateTime = DateTime(2023, 1, 1, 10, 0);
  final testTimerEntity = TimerEntity(
    id: 'test_timer_1',
    title: 'テストタイマー',
    timeSpecificationType: TimeSpecificationType.dateTime, // <<< 追加
    dateTime: testDateTime,
    timeRange: '10:00-11:00',
    timerType: TimerType.schedule,
    repeatType: RepeatType.none,
    characterIds: ['test_character_1'],
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
  });

  // 各テストの後に実行
  tearDown(() async {
    // Hiveテスト環境をクリーンアップ
    await hiveTestHelper.tearDown();
  });

  group('TimerRepositoryImpl', () {
    test('タイマーを保存して取得できること', () async {
      // タイマーを保存
      await timerRepository.saveTimer(testTimerEntity);

      // すべてのタイマーを取得
      final timers = await timerRepository.getAllTimers();

      // 検証
      expect(timers.length, 1);
      expect(timers[0].id, testTimerEntity.id);
      expect(timers[0].title, testTimerEntity.title);
      expect(timers[0].dateTime, testTimerEntity.dateTime);
      expect(timers[0].timeRange, testTimerEntity.timeRange);
      expect(timers[0].timerType, testTimerEntity.timerType);
      expect(timers[0].repeatType, testTimerEntity.repeatType);
      expect(timers[0].characterIds, testTimerEntity.characterIds);
      expect(
        timers[0].timeSpecificationType,
        testTimerEntity.timeSpecificationType,
      );
      expect(
        timers[0].startTimeOfDay?.hour,
        testTimerEntity.startTimeOfDay?.hour,
      );
      expect(
        timers[0].startTimeOfDay?.minute,
        testTimerEntity.startTimeOfDay?.minute,
      );
      expect(timers[0].endTimeOfDay?.hour, testTimerEntity.endTimeOfDay?.hour);
      expect(
        timers[0].endTimeOfDay?.minute,
        testTimerEntity.endTimeOfDay?.minute,
      );
    });

    test('IDでタイマーを取得できること', () async {
      // タイマーを保存
      await timerRepository.saveTimer(testTimerEntity);

      // IDでタイマーを取得
      final timer = await timerRepository.getTimerById(testTimerEntity.id);

      // 検証
      expect(timer, isNotNull);
      expect(timer!.id, testTimerEntity.id);
      expect(timer.title, testTimerEntity.title);
    });

    test('存在しないIDの場合はnullを返すこと', () async {
      // 存在しないIDでタイマーを取得
      final timer = await timerRepository.getTimerById('non_existent_id');

      // 検証
      expect(timer, isNull);
    });

    test('日付でタイマーを取得できること', () async {
      // タイマーを保存
      await timerRepository.saveTimer(testTimerEntity);

      // 同じ日付でタイマーを取得
      final timers = await timerRepository.getTimersByDateTime(
        DateTime(2023, 1, 1),
      );

      // 検証
      expect(timers.length, 1);
      expect(timers[0].id, testTimerEntity.id);
    });

    test('タイマーを削除できること', () async {
      // タイマーを保存
      await timerRepository.saveTimer(testTimerEntity);

      // タイマーを削除
      await timerRepository.deleteTimer(testTimerEntity.id);

      // すべてのタイマーを取得
      final timers = await timerRepository.getAllTimers();

      // 検証
      expect(timers.length, 0);
    });
  });
}
