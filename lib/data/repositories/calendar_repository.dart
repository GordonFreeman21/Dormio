import '../models/calendar_event.dart';
import '../services/calendar_service.dart';

class CalendarRepository {
  final CalendarService _calendarService;

  CalendarRepository(this._calendarService);

  Future<List<CalendarEvent>> getEventsForSession(DateTime start, DateTime end) async {
    return await _calendarService.getEventsAroundSession(start, end);
  }
}
