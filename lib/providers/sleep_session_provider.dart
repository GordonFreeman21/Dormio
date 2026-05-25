import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/sleep_session.dart';
import '../data/repositories/sleep_repository.dart';

final sleepRepositoryProvider = Provider((ref) => SleepRepository());

final sleepSessionsProvider = StateNotifierProvider<SleepSessionNotifier, List<SleepSession>>((ref) {
  return SleepSessionNotifier(ref.watch(sleepRepositoryProvider));
});

class SleepSessionNotifier extends StateNotifier<List<SleepSession>> {
  final SleepRepository _repository;

  SleepSessionNotifier(this._repository) : super([]) {
    loadSessions();
  }

  Future<void> loadSessions() async {
    state = await _repository.getAllSessions();
  }

  Future<void> saveSession(SleepSession session) async {
    await _repository.saveSession(session);
    await loadSessions();
  }

  Future<void> deleteSession(String id) async {
    await _repository.deleteSession(id);
    await loadSessions();
  }
}

final sessionDetailProvider = FutureProvider.family<SleepSession?, String>((ref, id) async {
  return ref.watch(sleepRepositoryProvider).getSession(id);
});
