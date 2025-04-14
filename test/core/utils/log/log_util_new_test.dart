import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate/core/utils/log/log_util_new.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  test('LogUtil can be used in tests', () {
    // Just verify that we can use the static methods without throwing
    LogUtil.d('Test debug message');
    LogUtil.i('Test info message');
    LogUtil.w('Test warning message');
    LogUtil.e('Test error message');
    
    // If we get here without exceptions, the test passes
    expect(true, isTrue);
  });
}
