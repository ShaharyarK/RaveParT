import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ravepart_app/screens/rave_screen.dart';
import '../widgets/custom_button.dart';
import 'dart:developer' as developer; // Import the developer library
import 'sound_sync_screen.dart';
import 'dart:async';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
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

  void _showAdAndNavigate(Widget screen) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd(); // Load a new ad after showing
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitialAd();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('RaveParT - Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              title: "Get The Rave Going!",
              fontColor: Colors.white,
              buttonColor: Colors.purpleAccent,
              onPressed: () => _showAdAndNavigate(RaveScreen()),
            ),
            SizedBox(height: 20),
            CustomButton(
              title: "Sound Sync Mode 🎶",
              fontColor: Colors.white,
              buttonColor: Colors.purpleAccent,
              onPressed: () => _showAdAndNavigate(SoundSyncScreen()),
            ),
            SizedBox(height: 20),
            CustomButton(
                title: "Settings",
                fontColor: Colors.white,
                buttonColor: Colors.purpleAccent,
                onPressed: () {}),
            SizedBox(height: 20),
            CustomButton(
                title: "About",
                fontColor: Colors.white,
                buttonColor: Colors.purpleAccent,
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
