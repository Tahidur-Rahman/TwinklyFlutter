import 'dart:math';

import 'package:flutter/material.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/LargeTitleText.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/get_started.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';

class Productivity extends StatefulWidget {
  const Productivity({super.key});

  @override
  State<Productivity> createState() => _ProductivityState();
}

class _ProductivityState extends State<Productivity>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> containerPosition;

  late Animation<double> rotationTurns;

  final List<String> titles = [
    "Goal-setting",
    "Dedication",
    "Workflow",
    "Efficiency",
    "Concentration",
    "Discipline",
    "Balance",
    "Productivity",
    "Time-manager",
    "Performance",
    "Focus."
  ];

  final double itemHeight = 55 * .83;

  final double topPadding = 80;

  final double extraSpaces = 200 + 20;

  @override
  void initState() {
    super.initState();
    final totalItems = titles.length;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    containerPosition = Tween<double>(
      begin: -380,
      end: itemHeight * totalItems + topPadding - extraSpaces,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    rotationTurns = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.77, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.focusButtonColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 5, right: 5, top: topPadding, bottom: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final title in titles)
                  LargeTitleText(title, const Color(0xffa75449)),
                const Spacer(),
                const GetStartedButton(),
                const SizedBox(height: 10),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-140, containerPosition.value),
                child: Transform.rotate(
                  angle: rotationTurns.value * 2 * pi,
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: Image.asset('assets/images/productivity/star.png'),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final normalized = containerPosition.value + 200 - itemHeight / 2 - topPadding;
              final itemIndex = (normalized / itemHeight).round();

              return Positioned(
                left: 5,
                top: containerPosition.value + 200 - itemHeight / 2,
                child: itemIndex >= 0 && itemIndex < titles.length
                    ? LargeTitleText(titles[itemIndex], Colors.black)
                    : const SizedBox(),
              );
            },
          ),
        ],
      ),
    );
  }
}
