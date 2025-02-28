import 'package:flutter/material.dart';
import 'package:ravepart_app/screens/rave_screen.dart';
import '../widgets/custom_button.dart';
import 'sound_sync_screen.dart'; // Import the new screen

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('RaveParT - Menu'),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RaveScreen()),
                  );
                }),
            SizedBox(height: 20),
            CustomButton(
                title: "Sound Sync Mode 🎶",
                fontColor: Colors.white,
                buttonColor: Colors.purpleAccent,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SoundSyncScreen()),
                  );
                }),
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
