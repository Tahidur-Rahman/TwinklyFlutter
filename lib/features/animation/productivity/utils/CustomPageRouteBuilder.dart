import 'package:flutter/material.dart';

class CustomPageRouteBuilder extends PageRouteBuilder {
  final Widget route;
  CustomPageRouteBuilder({required this.route})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) {
            return route;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
}
