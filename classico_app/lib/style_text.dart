
import 'package:flutter/material.dart';

class StyleText extends StatelessWidget {

  /// StyleText(String text,{super.key}): text = text; equivalent to StyleText(this.text,{super.key});
  const StyleText(this.text,{super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
    );
  }

}