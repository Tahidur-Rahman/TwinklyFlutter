import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color backgroundColor = Color(0xFFdcddd1);
  static const Color cardBackgroundColor = Colors.white;
  static const Color focusCardBackgroundColor = Color(0xFFF5E6D3);
  static const Color primaryTextColor = Colors.black;
  static const Color secondaryTextColor = Colors.black54;
  static const Color borderColor = Color(0xFFE5E5EA);
  static const Color chartColor = Color(0xFF8ed570);
  static const Color focusButtonColor = Color(0xFFee7262);
  static const Color redAccentColor = Color(0xFFE74C3C);

  // Text Styles
  static const TextStyle headerTitleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: primaryTextColor,
    height: 1.15
  );

  static const TextStyle headerSubtitleStyle = TextStyle(
    fontSize: 13,
    color: primaryTextColor,
    fontWeight: FontWeight.w400,
    height: 1.15
  );

  static const TextStyle sectionHeaderStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: primaryTextColor,
    letterSpacing: 0.5,
  );

  static const TextStyle largeNumberStyle = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w700,
    color: primaryTextColor,
    height: 1.0,
  );

  static const TextStyle mediumTextStyle = TextStyle(
    fontSize: 14,
    color: primaryTextColor,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle smallTextStyle = TextStyle(
    fontSize: 13,
    color: primaryTextColor,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle buttonSubtextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: backgroundColor,
    );
  }
}