import 'dart:typed_data';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'dart:developer' as developer; // Import the developer library

class AudioCaptureService {
  static final AudioCaptureService _instance = AudioCaptureService._internal();
  factory AudioCaptureService() => _instance;
  AudioCaptureService._internal();

  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
  bool isCapturing = false;

  Future<void> startCapture(Function(Float32List) onData) async {
    if (!isCapturing) {
      try {
        await _audioCapture.start(
          (data) {
            onData(data); // ✅ Ensure callback actually processes data
          },
          (error) {
            developer.log("❌ Music Capture Error: $error");
          },
          sampleRate: 22050, // Keep high sample rate for better sensitivity
        );
        isCapturing = true;
        developer.log("🎤 Music Capture Started");
      } catch (e) {
        developer.log("❌ Error starting music capture: $e");
      }
    }
  }

  void stopCapture() {
    if (isCapturing) {
      _audioCapture.stop();
      isCapturing = false;
      developer.log("🛑 Music Capture Stopped");
    }
  }
}
