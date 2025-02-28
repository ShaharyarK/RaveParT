import 'dart:typed_data';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';

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
            print("🔊 Capturing Surrounding Music...");
          },
          (error) {
            print("❌ Music Capture Error: $error");
          },
          sampleRate: 44100,
        );
        isCapturing = true;
        print("🎤 Music Capture Started");
      } catch (e) {
        print("❌ Error starting music capture: $e");
      }
    }
  }

  void stopCapture() {
    if (isCapturing) {
      _audioCapture.stop();
      isCapturing = false;
      print("🛑 Music Capture Stopped");
    }
  }
}
