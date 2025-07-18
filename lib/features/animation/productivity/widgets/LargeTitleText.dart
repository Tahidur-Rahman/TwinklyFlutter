import 'package:flutter/material.dart';

class LargeTitleText extends StatelessWidget {
  final String text;
  final Color color;
  const LargeTitleText(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 55,
        letterSpacing: -1,
        color: color,
        fontWeight: FontWeight.w500,
        height: .83,
      ),
    );
  }
}