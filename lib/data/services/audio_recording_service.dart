import 'dart:async';
import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AudioRecordingService {
  final _recorder = AudioRecorder();
  StreamController<double>? _amplitudeController;
  Timer? _amplitudeTimer;

  Stream<double> get amplitudeStream => _amplitudeController?.stream ?? const Stream.empty();

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<String> startRecording() async {
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) throw Exception('Microphone permission not granted');

    final directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/${const Uuid().v4()}.m4a';

    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: filePath);

    _amplitudeController = StreamController<double>.broadcast();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      final amplitude = await _recorder.getAmplitude();
      // amplitude.current is in dBFS, range is usually -160 to 0
      // Map it to 0-100 for easier visualization
      double db = (amplitude.current + 160) / 1.6;
      _amplitudeController?.add(db.clamp(0, 100));
    });

    return filePath;
  }

  Future<void> stopRecording() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    await _recorder.stop();
    await _amplitudeController?.close();
    _amplitudeController = null;
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
