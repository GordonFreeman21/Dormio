import 'package:hive/hive.dart';

part 'snore_event.g.dart';

@HiveType(typeId: 1)
class SnoreEvent extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime timestamp;

  @HiveField(2)
  late int durationSeconds;

  @HiveField(3)
  late double peakDb;

  @HiveField(4)
  late double confidence; // 0.0–1.0 how sure we are it's a snore

  SnoreEvent({
    required this.id,
    required this.timestamp,
    required this.durationSeconds,
    required this.peakDb,
    required this.confidence,
  });
}
