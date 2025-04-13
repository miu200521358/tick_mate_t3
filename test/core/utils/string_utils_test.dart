import 'package:flutter_test/flutter_test.dart';
import 'package:tick_mate/core/utils/string_utils.dart';

void main() {
  group('StringUtils', () {
    test('isNullOrEmpty returns true for null', () {
      expect(StringUtils.isNullOrEmpty(null), isTrue);
    });

    test('isNullOrEmpty returns true for empty string', () {
      expect(StringUtils.isNullOrEmpty(''), isTrue);
    });

    test('isNullOrEmpty returns false for non-empty string', () {
      expect(StringUtils.isNullOrEmpty('test'), isFalse);
    });
  });
}
