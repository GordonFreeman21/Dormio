import 'dart:math';
import 'package:fftea/fftea.dart';

class AudioAnalyzer {
  /// Analyzes a chunk of audio data and returns the dominant frequency and its magnitude.
  static Map<String, double> analyzeChunk(List<double> samples, int sampleRate) {
    if (samples.isEmpty) return {'frequency': 0.0, 'magnitude': 0.0};

    // Apply FFT
    final fft = FFT(samples.length);
    final freqData = fft.realFft(samples);
    final magnitudes = freqData.magnitudes();

    double maxMagnitude = -1.0;
    int maxIndex = -1;

    // We only care about the first half of magnitudes (Nyquist frequency)
    for (int i = 0; i < magnitudes.length / 2; i++) {
      if (magnitudes[i] > maxMagnitude) {
        maxMagnitude = magnitudes[i];
        maxIndex = i;
      }
    }

    if (maxIndex == -1) return {'frequency': 0.0, 'magnitude': 0.0};

    final frequency = maxIndex * sampleRate / samples.length;

    return {
      'frequency': frequency,
      'magnitude': maxMagnitude,
    };
  }

  /// Calculates dB level from raw amplitude data.
  static double calculateDb(List<double> samples) {
    if (samples.isEmpty) return 0.0;

    double sumSquares = 0.0;
    for (var sample in samples) {
      sumSquares += sample * sample;
    }

    double rms = sqrt(sumSquares / samples.length);
    if (rms == 0) return 0.0;

    // 20 * log10(rms) - assuming samples are normalized to [-1, 1]
    // We add an offset to get a range roughly 0-100
    double db = 20 * log(rms) / ln10 + 100;
    return db.clamp(0.0, 120.0);
  }
}
