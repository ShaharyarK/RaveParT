import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ravepart_app/screens/loading_screen.dart';
import 'providers/sound_sync_provider.dart';
import 'screens/sound_sync_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();

  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: [
        '7111838b-8088-4a1f-bdca-e13d4a2fba96',
        'd3e6df8e-17f9-4443-ba30-9898b185443e'
      ],
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SoundSyncProvider()),
      ],
      child: RaveParTApp(),
    ),
  );
}

class RaveParTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}
