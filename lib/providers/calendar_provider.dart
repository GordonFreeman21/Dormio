import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/calendar_event.dart';
import '../data/services/calendar_service.dart';
import '../data/repositories/calendar_repository.dart';

final calendarServiceProvider = Provider((ref) => CalendarService());
final calendarRepositoryProvider = Provider((ref) => CalendarRepository(ref.watch(calendarServiceProvider)));

final calendarEventsProvider = FutureProvider.family<List<CalendarEvent>, ({DateTime start, DateTime end})>((ref, range) async {
  return ref.watch(calendarRepositoryProvider).getEventsForSession(range.start, range.end);
});
