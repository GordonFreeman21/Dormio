import 'package:hive/hive.dart';
import 'snore_event.dart';

part 'sleep_session.g.dart';

@HiveType(typeId: 0)
class SleepSession extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime startTime;

  @HiveField(2)
  late DateTime? endTime;

  @HiveField(3)
  late int sleepScore; // 0–100

  @HiveField(4)
  late int totalSnoreMinutes;

  @HiveField(5)
  late int snoreEventCount;

  @HiveField(6)
  late double averageNoiseDb;

  @HiveField(7)
  late String? audioFilePath; // path to the compressed night recording

  @HiveField(8)
  late List<SnoreEvent> snoreEvents;

  @HiveField(9)
  late List<String> calendarEventIds; // correlated calendar events from that day

  @HiveField(10)
  late Map<String, double> sleepStages; // estimated % in light/deep/rem

  @HiveField(11)
  late String? userNotes;

  SleepSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.sleepScore = 0,
    this.totalSnoreMinutes = 0,
    this.snoreEventCount = 0,
    this.averageNoiseDb = 0,
    this.audioFilePath,
    this.snoreEvents = const [],
    this.calendarEventIds = const [],
    this.sleepStages = const {},
    this.userNotes,
  });
}
