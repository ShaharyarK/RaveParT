import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';

class RaveScreen extends StatefulWidget {
  @override
  _RaveScreenState createState() => _RaveScreenState();
}

class _RaveScreenState extends State<RaveScreen> {
  final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
  Color _backgroundColor = Colors.black;
  bool _isFlashing = true;
  double _flashSpeed = 300; // Default speed
  String _mode = "Strobe"; // Default Mode

  @override
  void initState() {
    super.initState();
    _startLightShow();
    _startAudioCapture();
  }

  void _startLightShow() {
    Timer.periodic(Duration(milliseconds: _flashSpeed.toInt()), (timer) {
      if (!_isFlashing) {
        timer.cancel();
      } else {
        setState(() {
          _backgroundColor = _getRandomColor();
        });
      }
    });
  }

  void _startAudioCapture() async {
    await _audioCapture.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);
  }

  void listener(dynamic obj) {
    List<double> audioSamples = List<double>.from(obj);
    double avgVolume =
        audioSamples.fold(0.0, (double sum, val) => sum + val.abs());
    audioSamples.length;

    if (_mode == "Sound Sync") {
      if (avgVolume > 0.02) {
        setState(() {
          _backgroundColor = _getRandomColor();
        });
      }
    }
  }

  void onError(Object error) {
    print("Audio Capture Error: $error");
  }

  Color _getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  void _changeMode(String newMode) {
    setState(() {
      _mode = newMode;
    });
  }

  void _changeSpeed(double newSpeed) {
    setState(() {
      _flashSpeed = newSpeed;
      _startLightShow();
    });
  }

  @override
  void dispose() {
    _audioCapture.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: _mode == "Pulse" ? 600 : 250),
        color: _backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isFlashing = !_isFlashing;
                  if (_isFlashing) {
                    _startLightShow();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                _isFlashing ? "Stop Rave" : "Start Rave",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text("Light Speed",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Slider(
              value: _flashSpeed,
              min: 100,
              max: 1000,
              divisions: 9,
              label: "${_flashSpeed.toInt()} ms",
              onChanged: _changeSpeed,
              activeColor: Colors.purpleAccent,
              inactiveColor: Colors.grey,
            ),
            SizedBox(height: 20),
            Text("Light Mode",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            Wrap(
              spacing: 10,
              children: ["Strobe", "Pulse", "Flash", "Sound Sync"].map((mode) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _mode == mode ? Colors.purpleAccent : Colors.black87,
                  ),
                  onPressed: () => _changeMode(mode),
                  child: Text(mode, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
