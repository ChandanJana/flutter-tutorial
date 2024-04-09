import 'package:classico_app/gradient_container.dart';
import 'package:flutter/material.dart';

void main() {
  /// main automatically executed by dart
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: GradientContainer(
        'Hello Flutter!!!',
        colorList: [
          Colors.deepPurpleAccent,
          Colors.yellow,
        ],
      ),
    ),
  ));

  /// runApp tell flutter what to display on the screen
}
