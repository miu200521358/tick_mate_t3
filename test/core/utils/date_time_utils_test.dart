import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate_t3/core/utils/date_time_utils.dart';

void main() {
  group('DateTimeUtils', () {
    test('formatDateTime formats correctly with default pattern', () {
      final dateTime = DateTime(2024, 4, 12, 10, 30, 15);
      expect(DateTimeUtils.formatDateTime(dateTime), '2024-04-12 10:30');
    });

    test('formatDateTime formats correctly with custom pattern', () {
      final dateTime = DateTime(2024, 4, 12, 10, 30, 15);
      expect(
        DateTimeUtils.formatDateTime(dateTime, pattern: 'dd/MM/yyyy'),
        '12/04/2024',
      );
    });

    // Add more tests for edge cases or other functions if needed
  });
}
