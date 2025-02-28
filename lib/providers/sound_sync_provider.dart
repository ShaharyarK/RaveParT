import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/audio_capture_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundSyncProvider extends ChangeNotifier {
  bool _isCapturing = false;
  bool get isCapturing => _isCapturing;

  final AudioCaptureService _audioCaptureService = AudioCaptureService();

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      print("🎤 Microphone Permission Granted!");
    } else {
      print("❌ Microphone Permission Denied!");
    }
  }

  Future<void> loadCaptureState() async {
    final prefs = await SharedPreferences.getInstance();
    bool shouldCapture = prefs.getBool('enable_audio_capture') ?? false;

    if (shouldCapture) {
      startCapture();
    }
  }

  void startCapture() {
    if (!_isCapturing) {
      _audioCaptureService.startCapture((data) {
        print("🔊 Capturing Audio Data...");
      });
      _isCapturing = true;
      notifyListeners();
    }
  }

  void stopCapture() {
    if (_isCapturing) {
      _audioCaptureService.stopCapture();
      _isCapturing = false;
      notifyListeners();
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
}
