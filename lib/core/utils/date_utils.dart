import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  static String formatWeekday(DateTime date) {
    return DateFormat('E').format(date);
  }
}
