import 'dart:async';
import 'dart:math';
import 'dart:developer' as developer; // Import the developer library
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_capture_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_stream/sound_stream.dart';

class SoundSyncProvider extends ChangeNotifier {
  final RecorderStream _recorder = RecorderStream();
  StreamSubscription? _audioSubscription;
  bool _isCapturing = false;
  bool get isCapturing => _isCapturing;
  double _currentVolume = 0.0;
  double get volumeLevel => _currentVolume;

  final AudioCaptureService _audioCaptureService = AudioCaptureService();

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      developer.log("🎤 Microphone Permission Granted!",
          name: 'SoundSyncProvider');
    } else {
      developer.log("❌ Microphone Permission Denied!",
          name: 'SoundSyncProvider');
    }
  }

  Future<void> loadCaptureState() async {
    final prefs = await SharedPreferences.getInstance();
    bool shouldCapture = prefs.getBool('enable_audio_capture') ?? false;

    if (shouldCapture) {
      startCapture();
    }
  }

  void startCapture() async {
    if (_isCapturing) return;
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      developer.log("🚨 Microphone permission required before capturing!",
          name: 'SoundSyncProvider');
      return;
    }

    if (!_isCapturing) {
      await _recorder.initialize(); // Ensure initialization before usage
      await _recorder.start();
      _audioSubscription = _recorder.audioStream.listen((event) {
        _processAudio(event);
      });
      await _audioCaptureService.startCapture((data) {
        _processAudio(data.buffer.asInt8List()); // 🔥 Ensure data is passed
      });

      _isCapturing = true;
      notifyListeners();
    }
  }

  void stopCapture() {
    if (_isCapturing) {
      _recorder.stop();
      _audioCaptureService.stopCapture();
      _isCapturing = false;
      notifyListeners();
      _audioSubscription?.cancel();
      _currentVolume = 0.0;
    }
  }

  Future<void> setCaptureEnabled(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enable_audio_capture', isEnabled);

    if (isEnabled) {
      startCapture();
    } else {
      stopCapture();
    }
  }

  void _processAudio(List<int> audioBytes) {
    List<double> signal = audioBytes.map((b) => b.toDouble()).toList();
    int min = audioBytes.reduce((a, b) => a < b ? a : b);
    int max = audioBytes.reduce((a, b) => a > b ? a : b);
    developer.log("🔊 Min Volume: $min, Max Volume: $max",
        name: 'SoundSyncProvider');

    // Calculate RMS
    double rms = sqrt(
        signal.fold<double>(0.0, (sum, val) => sum + (val * val)) /
            signal.length);

    // 🔥 Normalize dynamically (adjust divisor based on RMS range)
    double normalizedVolume = (rms / 250).clamp(0.0, 1.0);

    // 🚀 Boost sensitivity if volume is too low
    if (normalizedVolume < 0.05) {
      normalizedVolume *= 3; // Amplify very low signals
    }

    _currentVolume = normalizedVolume.clamp(0.0, 1.0);

    notifyListeners();
  }
}
