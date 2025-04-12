import 'package:intl/intl.dart';

class DateTimeUtils {
  static String formatDateTime(
    DateTime dateTime, {
    String pattern = 'yyyy-MM-dd HH:mm',
  }) {
    return DateFormat(pattern).format(dateTime);
  }

  // Add other date/time utility functions
}
