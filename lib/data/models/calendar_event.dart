class CalendarEvent {
  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final bool isEarlyMorning; // starts before 9am
  final bool isLateNight; // ends after 10pm
  final String? category; // 'work', 'social', 'health', etc. (inferred from title)

  CalendarEvent({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.isEarlyMorning,
    required this.isLateNight,
    this.category,
  });
}
