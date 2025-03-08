import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torch_light/torch_light.dart';
import '../providers/sound_sync_provider.dart';
import 'dart:developer' as developer; // Import the developer library
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RaveScreen extends StatefulWidget {
  @override
  _RaveScreenState createState() => _RaveScreenState();
}

// Define a custom data structure for animations
class RaveAnimation {
  final String assetPath;
  final bool rotate;
  final bool scale;
  final bool pulse;
  final bool glowAndLasers; // New property for glow and lasers
  final double sizeFactor; // New property for custom size

  RaveAnimation({
    required this.assetPath,
    this.rotate = false,
    this.scale = false,
    this.pulse = false,
    this.glowAndLasers = false, // Default to false
    this.sizeFactor = 1.0, // Default to full size
  });
}

class _RaveScreenState extends State<RaveScreen> {
  InterstitialAd? _interstitialAd;

  Color _backgroundColor = Colors.black;
  bool _isFlashing = true;
  double _flashSpeed = 300;
  String _mode = "Strobe";
  bool _isFlasherEnabled = false;
  Timer? _flashTimer;
  bool _hideControls = false;
  bool _showHint = true; // Show hint only the first time
  double _rotationTurns = 0.0; // Track rotation turns for the disco ball
  Timer? _rotationTimer; // Timer for disco ball rotation
  double _scale = 1.0; // Track scaling for animations
  bool _isScalingUp = true; // Track scaling direction
  int maxFlashSpeed = 1050;

  @override
  void initState() {
    super.initState();
    // _initializeAd();
    _loadInterstitialAd();
    _startLightShow();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showHint = false; // Hide hint after a few seconds
      });
    });

    // Start rotation animation with a constant frame rate (60 FPS)
    _rotationTimer = Timer.periodic(
      Duration(milliseconds: 16), // ~60 FPS
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          // Adjust rotation speed based on _flashSpeed
          _rotationTurns +=
              0.01 * ((maxFlashSpeed - _flashSpeed) / 200); // Normalize speed
        });
      },
    );

    // Start scaling animation
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_isScalingUp) {
          _scale += 0.03;
          if (_scale >= 1.3) _isScalingUp = false;
        } else {
          _scale -= 0.03;
          if (_scale <= 1.0) _isScalingUp = true;
        }
      });
    });
  }

  Future<void> _initializeAd() async {
    bool adLoaded = await _loadInterstitialAd();
    if (adLoaded) {
      _showAd(); // Only show if ad successfully loaded
    }
  }

  Future<bool> _loadInterstitialAd() async {
    Completer<bool> completer = Completer<bool>();

    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-3940256099942544/1033173712', // Replace with your AdMob Ad Unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
          });

          // Handle ad close events
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              developer.log("Ad dismissed. Loading a new one...");
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd(); // Load next ad immediately
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              developer.log("Ad failed to show: ${error.message}");
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd(); // Load next ad on failure too
            },
          );

          developer.log("Ad loaded successfully!");
          completer.complete(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          developer.log("Failed to load ad: ${error.message}");
          _interstitialAd = null;
          completer.complete(false);
        },
      ),
    );

    return completer.future;
  }

  void _showAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Prevent multiple show calls
    } else {
      developer.log("Ad not ready yet.");
    }
  }

  // List of animations with their properties
  List<RaveAnimation> raveAnimations = [
    RaveAnimation(
      assetPath: 'assets/disco_ball.png',
      rotate: true,
      // glowAndLasers: true, // Enable glow and lasers for disco ball
      sizeFactor: 0.7, // Half the size
    ),
    RaveAnimation(
      assetPath: 'assets/trance_eye.png',
      rotate: true,
      // scale: true,
      // glowAndLasers: true, // Enable glow and lasers for trance eye
      sizeFactor: 0.85, // 60% of the screen size
    ),
    RaveAnimation(
      assetPath: 'assets/eye_in_eye.gif',
      // rotate: true,
      // scale: true,
      // glowAndLasers: true, // Enable glow and lasers for trance eye
      sizeFactor: 0.85, // 60% of the screen size
    ),
    RaveAnimation(
      assetPath: 'assets/lsd_girl_third_eye.gif',
      // rotate: true,
      // scale: true,
      // glowAndLasers: true, // Enable glow and lasers for trance eye
      sizeFactor: 0.85, // 60% of the screen size
    ),
    RaveAnimation(
      assetPath: 'assets/lsd_cat.gif',
      // rotate: true,
      // scale: true,
      // glowAndLasers: true, // Enable glow and lasers for trance eye
      sizeFactor: 0.85, // 60% of the screen size
    ),
    RaveAnimation(
      assetPath: 'assets/trance_girl_dancing.gif',
      // rotate: true,
      // scale: true,
      // glowAndLasers: true, // Enable glow and lasers for trance eye
      sizeFactor: 1, // 60% of the screen size
    ),
    RaveAnimation(
      assetPath: 'assets/halogen_ball.gif',
      rotate: true,
      // scale: true,
      // glowAndLasers: true, // Enable glow and lasers for trance eye
      sizeFactor: 1, // 60% of the screen size
    ),
    RaveAnimation(
      assetPath: 'assets/thought_kid.gif',
      // rotate: true,
      // scale: true,
      // glowAndLasers: true, // Enable glow and lasers for trance eye
      sizeFactor: 0.85, // 60% of the screen size
    ),
    // RaveAnimation(
    //   assetPath: 'assets/equalizer_bars.gif',
    //   pulse: true,
    //   sizeFactor: 0.8, // 80% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/neon_hands.gif',
    //   sizeFactor: 0.7, // 70% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/led_lights.gif',
    //   sizeFactor: 0.9, // 90% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/dj_turntable.gif',
    //   sizeFactor: 0.75, // 75% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/fireworks.gif',
    //   sizeFactor: 1.0, // Full size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/psychedelic_swirl.gif',
    //   sizeFactor: 0.85, // 85% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/music_notes.gif',
    //   sizeFactor: 0.65, // 65% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/holographic_face.gif',
    //   sizeFactor: 0.7, // 70% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/strobe_light.gif',
    //   sizeFactor: 0.8, // 80% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/rave_crowd.png',
    //   sizeFactor: 1.0, // Full size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/cyberpunk_skyline.png',
    //   sizeFactor: 0.9, // 90% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/glowstick_trails.gif',
    //   sizeFactor: 0.75, // 75% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/flaming_bass_drop.gif',
    //   sizeFactor: 0.8, // 80% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/holographic_text.gif',
    //   sizeFactor: 0.7, // 70% of the screen size
    // ),
    // RaveAnimation(
    //   assetPath: 'assets/tron_grid.gif',
    //   sizeFactor: 0.85, // 85% of the screen size
    // ),
  ];

  int currentAnimationIndex = 0;

  // Function to change the animation on left/right swipe
  void _changeAnimation(bool isRight) {
    setState(() {
      if (isRight) {
        currentAnimationIndex =
            (currentAnimationIndex + 1) % raveAnimations.length;
      } else {
        currentAnimationIndex =
            (currentAnimationIndex - 1 + raveAnimations.length) %
                raveAnimations.length;
      }
    });
  }

  void _startLightShow() {
    _flashTimer?.cancel();
    _flashTimer = Timer.periodic(
      Duration(milliseconds: _flashSpeed.toInt()),
      (timer) {
        if (!_isFlashing || !mounted) {
          timer.cancel();
          _turnOffFlash();
        } else {
          setState(() {
            if (_mode == "Flash") {
              _backgroundColor = _backgroundColor == Colors.white
                  ? Colors.black
                  : Colors.white;
            } else {
              _backgroundColor = _getRandomColor();
            }
          });
          if (_isFlasherEnabled) {
            _syncFlashWithMode();
          }
        }
      },
    );
  }

  void _syncFlashWithMode() async {
    try {
      switch (_mode) {
        case "Strobe":
          await TorchLight.enableTorch();
          await Future.delayed(
              Duration(milliseconds: (_flashSpeed ~/ 2).toInt()));
          await TorchLight.disableTorch();
          break;
        case "Pulse":
          await TorchLight.enableTorch();
          await Future.delayed(Duration(milliseconds: _flashSpeed.toInt()));
          await TorchLight.disableTorch();
          break;
        case "Flash":
          await TorchLight.enableTorch();
          await Future.delayed(
              Duration(milliseconds: (_flashSpeed ~/ 2).toInt()));
          await TorchLight.disableTorch();
          break;
        case "Sound Sync":
          final soundSyncProvider =
              Provider.of<SoundSyncProvider>(context, listen: false);
          double volume = soundSyncProvider.volumeLevel;
          if (volume > 0.1) {
            int baseDuration = (volume * 500).toInt();
            int adjustedDuration = (baseDuration ~/ _flashSpeed).clamp(50, 800);

            await TorchLight.enableTorch();
            await Future.delayed(Duration(milliseconds: adjustedDuration));
            await TorchLight.disableTorch();
          }
          break;
      }
    } catch (e) {
      developer.log("Flashlight Error: $e");
    }
  }

  void _turnOffFlash() async {
    try {
      await TorchLight.disableTorch();
    } catch (e) {
      developer.log("Error turning off flash: $e");
    }
  }

  void _changeMode(String newMode) {
    setState(() {
      _mode = newMode;
      _startLightShow();
    });
  }

  void _changeSpeed(double newSpeed) {
    setState(() {
      _flashSpeed = maxFlashSpeed - newSpeed; // Inverts the value
      _startLightShow();
    });
  }

  void _toggleFlasher(bool enabled) {
    setState(() {
      _isFlasherEnabled = enabled;
      if (!enabled) _turnOffFlash();
    });
  }

  Color _getRandomColor() {
    return Color.fromRGBO(
      Random().nextInt(256),
      Random().nextInt(256),
      Random().nextInt(256),
      1,
    );
  }

  @override
  void dispose() {
    // Provider.of<SoundSyncProvider>(context, listen: false).stopCapture();
    _flashTimer?.cancel();
    _rotationTimer?.cancel();
    _turnOffFlash();
    if (_interstitialAd != null) {
      _showAd(); // Show ad before disposing
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentAnimation = raveAnimations[currentAnimationIndex];

    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! < -10) {
            setState(() => _hideControls = true); // Swipe up hides controls
          } else if (details.primaryDelta! > 10) {
            setState(() => _hideControls = false); // Swipe down shows controls
          }
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            _changeAnimation(false); // Swipe right to go left
          } else if (details.primaryVelocity! < 0) {
            _changeAnimation(true); // Swipe left to go right
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: _mode == "Pulse" ? 600 : 250),
          color: _backgroundColor,
          child: Stack(
            children: [
              // Controls UI (Show/Hide based on swipe)
              if (!_hideControls)
                Column(
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                      value: maxFlashSpeed - _flashSpeed,
                      min: 50,
                      max: 1000,
                      divisions: 19,
                      label: "${(_flashSpeed).toInt()} ms",
                      onChanged: _changeSpeed,
                      activeColor: Colors.purpleAccent,
                      inactiveColor: Colors.grey,
                    ),
                    SizedBox(height: 20),
                    Text("Light Mode",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Wrap(
                      spacing: 10,
                      children: ["Strobe", "Pulse", "Flash", "Sound Sync"]
                          .map((mode) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _mode == mode
                                ? Colors.purpleAccent
                                : Colors.black87,
                          ),
                          onPressed: () => _changeMode(mode),
                          child:
                              Text(mode, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Enable Flasher",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        Switch(
                          value: _isFlasherEnabled,
                          onChanged: _toggleFlasher,
                          activeColor: Colors.purpleAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              // Swipe Hint at the Top
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: _showHint ? 1.0 : 0.0,
                  child: Column(
                    children: [
                      Icon(Icons.swipe_up, color: Colors.white, size: 40),
                      SizedBox(height: 10),
                      Text("Swipe up to hide controls",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(height: 5),
                      Text("Swipe down to show controls",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              // Animation Display (Only shown when controls are hidden)
              if (_hideControls)
                Center(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Stack(
                      children: [
                        Transform(
                          key: ValueKey<int>(currentAnimationIndex),
                          alignment:
                              Alignment.center, // Rotate around the center
                          transform: Matrix4.identity()
                            ..rotateZ(_rotationTurns *
                                (currentAnimation.rotate ? 1 : 0))
                            ..scale(currentAnimation.scale
                                ? _scale
                                : 1.0), // Apply scaling only if scale is true
                          child: Image.asset(
                            currentAnimation.assetPath,
                            width: MediaQuery.of(context).size.width *
                                currentAnimation.sizeFactor, // Use custom size
                            height: MediaQuery.of(context).size.height *
                                currentAnimation.sizeFactor, // Use custom size
                            fit: BoxFit.contain,
                          ),
                        ),
                        if (currentAnimation.glowAndLasers)
                          _GlowAndLasersEffect(
                            rotationTurns: _rotationTurns,
                            flashSpeed: _flashSpeed,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget for glow and lasers effect
class _GlowAndLasersEffect extends StatelessWidget {
  final double rotationTurns;
  final double flashSpeed;

  const _GlowAndLasersEffect({
    required this.rotationTurns,
    required this.flashSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.transparent,
          ],
          stops: [0.0, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.overlay,
      child: Transform.rotate(
        angle: rotationTurns * 2 * pi,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Colors.white.withOpacity(0.8),
                Colors.transparent,
              ],
              stops: [0.0, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
