import 'package:flutter/material.dart';
import 'dart:async';
import 'menu_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimationInnov8;
  late Animation<Offset> _slideAnimationRaveParT;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _slideAnimationInnov8 = Tween<Offset>(
      begin: Offset(0, -1), // Starts above the screen
      end: Offset(0, 0), // Moves to center
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimationRaveParT = Tween<Offset>(
      begin: Offset(-1, 0), // Starts off-screen left
      end: Offset(0, 0), // Moves to center
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();

    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _slideAnimationInnov8,
              child: Text(
                'Innov8',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent,
                  letterSpacing: 2,
                ),
              ),
            ),
            SizedBox(height: 10),
            SlideTransition(
              position: _slideAnimationRaveParT,
              child: Text(
                'RaveParT',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.purpleAccent),
            SizedBox(height: 40),
            Text(
              'Made by Shaharyar with 💜',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
