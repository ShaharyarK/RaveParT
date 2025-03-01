import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sound_sync_provider.dart';

class SoundSyncScreen extends StatefulWidget {
  @override
  _SoundSyncScreenState createState() => _SoundSyncScreenState();
}

class _SoundSyncScreenState extends State<SoundSyncScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soundSyncProvider = context.read<SoundSyncProvider>();
      soundSyncProvider.requestMicrophonePermission();
      soundSyncProvider.loadCaptureState(); // Load user preference
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundSyncProvider =
        Provider.of<SoundSyncProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sound Sync Mode"),
        actions: [
          IconButton(
            icon: Icon(
                soundSyncProvider.isCapturing ? Icons.stop : Icons.play_arrow),
            onPressed: () {
              soundSyncProvider
                  .setCaptureEnabled(!soundSyncProvider.isCapturing);
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          soundSyncProvider.isCapturing
              ? "Capturing Music..."
              : "Music Capture Stopped",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
