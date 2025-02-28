import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:torch_light/torch_light.dart';

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
  bool _isFlasherEnabled = false; // Controls flashlight effect
  Timer? _flashTimer; // Store the Timer instance

  @override
  void initState() {
    super.initState();
    _startLightShow();
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

  void _startLightShow() {
    _flashTimer?.cancel(); // Cancel existing timer before starting a new one
    _flashTimer =
        Timer.periodic(Duration(milliseconds: _flashSpeed.toInt()), (timer) {
      if (!_isFlashing || !mounted) {
        timer.cancel();
        _turnOffFlash();
      } else {
        if (mounted) {
          setState(() {
            _backgroundColor = _getRandomColor();
            if (_isFlasherEnabled) {
              _toggleFlash();
            }
          });
        }
      }
    });
  }

  void _toggleFlash() async {
    try {
      await TorchLight.enableTorch();
      await Future.delayed(Duration(milliseconds: (_flashSpeed ~/ 2).toInt()));
      await TorchLight.disableTorch();
    } catch (e) {
      print("Flashlight Error: $e");
    }
  }

  void _turnOffFlash() async {
    try {
      await TorchLight.disableTorch();
    } catch (e) {
      print("Error turning off flash: $e");
    }
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

  void _toggleFlasher(bool enabled) {
    setState(() {
      _isFlasherEnabled = enabled;
      if (!enabled) _turnOffFlash(); // Turn off flash if disabled
    });
  }

  @override
  void dispose() {
    _audioCapture.stop();
    _flashTimer?.cancel();
    _turnOffFlash(); // Ensure flash is turned off on exit
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
                  } else {
                    _flashTimer?.cancel();
                    _turnOffFlash();
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enable Flasher",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Switch(
                  value: _isFlasherEnabled,
                  onChanged: _toggleFlasher,
                  activeColor: Colors.purpleAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
