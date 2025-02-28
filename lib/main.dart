import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ravepart_app/screens/loading_screen.dart';
import 'providers/sound_sync_provider.dart';
import 'screens/sound_sync_screen.dart';

void main() {
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
