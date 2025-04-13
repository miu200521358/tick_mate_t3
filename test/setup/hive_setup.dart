import 'package:flutter_test/flutter_test.dart';

import '../helpers/hive_test_helper.dart';

/// テスト全体で共通のHiveセットアップを提供する
void setupHiveForTesting() {
  // テスト実行前に一度だけ実行
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  // 各テストの前に実行
  setUp(() async {
    await HiveTestHelper().setUp();
  });

  // 各テストの後に実行
  tearDown(() async {
    await HiveTestHelper().tearDown();
  });
}
