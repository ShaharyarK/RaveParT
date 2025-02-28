import 'package:flutter/material.dart';
import 'package:ravepart_app/screens/loading_screen.dart';

void main() {
  runApp(RaveParTApp());
}

class RaveParTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RaveParT - Disco Lights',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}
