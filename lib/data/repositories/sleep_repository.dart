import 'package:hive/hive.dart';
import '../models/sleep_session.dart';

class SleepRepository {
  static const String _boxName = 'sessions';

  Future<Box<SleepSession>> get _box async => await Hive.openBox<SleepSession>(_boxName);

  Future<void> saveSession(SleepSession session) async {
    final box = await _box;
    await box.put(session.id, session);
  }

  Future<List<SleepSession>> getAllSessions() async {
    final box = await _box;
    return box.values.toList()..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  Future<SleepSession?> getSession(String id) async {
    final box = await _box;
    return box.get(id);
  }

  Future<void> deleteSession(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
