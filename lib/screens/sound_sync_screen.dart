import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';

class SoundSyncScreen extends StatefulWidget {
  @override
  _SoundSyncScreenState createState() => _SoundSyncScreenState();
}

class _SoundSyncScreenState extends State<SoundSyncScreen> {
  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
  bool isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioCapture();
  }

  Future<void> _initializeAudioCapture() async {
    try {
      await _audioCapture.init();
      print("🎤 FlutterAudioCapture Initialized Successfully!");
    } catch (e) {
      print("❌ Error initializing audio capture: $e");
    }
  }

  void _startCapture() async {
    if (!isCapturing) {
      try {
        await _audioCapture.start((data) {
          print("🔊 Capturing Audio Data...");
        }, sampleRate: 44100);
        setState(() {
          isCapturing = true;
        });
      } catch (e) {
        print("❌ Error starting audio capture: $e");
      }
    }
  }

  void _stopCapture() async {
    if (isCapturing) {
      await _audioCapture.stop();
      setState(() {
        isCapturing = false;
      });
      print("🛑 Stopped Audio Capture.");
    }
  }

  @override
  void dispose() {
    _audioCapture.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sound Sync Mode")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startCapture,
              child: Text("Start Sound Sync"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _stopCapture,
              child: Text("Stop"),
            ),
          ],
        ),
      ),
    );
  }
}
