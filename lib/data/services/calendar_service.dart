import 'package:device_calendar/device_calendar.dart';
import '../models/calendar_event.dart' as model;

class CalendarService {
  final DeviceCalendarPlugin _calendarPlugin = DeviceCalendarPlugin();

  Future<bool> requestPermission() async {
    final permissionsGranted = await _calendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && (permissionsGranted.data ?? false)) {
      return true;
    }
    final request = await _calendarPlugin.requestPermissions();
    return request.isSuccess && (request.data ?? false);
  }

  Future<List<model.CalendarEvent>> getEventsAroundSession(DateTime start, DateTime end) async {
    final hasPermission = await _calendarPlugin.hasPermissions();
    if (!hasPermission.isSuccess || !(hasPermission.data ?? false)) return [];

    final calendars = await _calendarPlugin.retrieveCalendars();
    if (!calendars.isSuccess || calendars.data == null) return [];

    List<model.CalendarEvent> allEvents = [];

    // Buffer: 6am the previous day through noon the day of wakeup
    final fetchStart = DateTime(start.year, start.month, start.day - 1, 6);
    final fetchEnd = DateTime(end.year, end.month, end.day, 12);

    for (var calendar in calendars.data!) {
      final events = await _calendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(startDate: fetchStart, endDate: fetchEnd),
      );

      if (events.isSuccess && events.data != null) {
        for (var event in events.data!) {
          if (event.eventId == null || event.title == null || event.start == null || event.end == null) continue;

          final startTime = event.start!;
          final endTime = event.end!;

          allEvents.add(model.CalendarEvent(
            id: event.eventId!,
            title: event.title!,
            start: startTime,
            end: endTime,
            isEarlyMorning: startTime.hour < 9,
            isLateNight: endTime.hour >= 22,
            category: _inferCategory(event.title!),
          ));
        }
      }
    }

    return allEvents;
  }

  String _inferCategory(String eventTitle) {
    final title = eventTitle.toLowerCase();
    if (title.contains('standup') ||
        title.contains('meeting') ||
        title.contains('review') ||
        title.contains('interview') ||
        title.contains('presentation') ||
        title.contains('work')) {
      return 'work';
    }
    if (title.contains('dinner') ||
        title.contains('party') ||
        title.contains('drinks') ||
        title.contains('birthday') ||
        title.contains('social')) {
      return 'social';
    }
    if (title.contains('gym') ||
        title.contains('run') ||
        title.contains('yoga') ||
        title.contains('workout') ||
        title.contains('health')) {
      return 'health';
    }
    return 'other';
  }
}
