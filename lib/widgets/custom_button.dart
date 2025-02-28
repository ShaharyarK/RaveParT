import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color fontColor;
  final Color buttonColor;
  final VoidCallback onPressed;

  CustomButton(
      {required this.title,
      required this.fontColor,
      required this.buttonColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: fontColor)),
    );
  }
}
