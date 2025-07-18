import 'package:flutter/material.dart';
import 'package:twinkly_flutter/features/animation/productivity/utils/app_usage_data.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/custom_button.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/focus_score_section.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/header_section.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/screen_time_section.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';

class AnimatedEntrance extends StatelessWidget {
  final Animation<double> scale;
  final Animation<Offset> position;
  final Widget child;

  const AnimatedEntrance({
    required this.scale,
    required this.position,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: SlideTransition(
        position: position,
        child: child,
      ),
    );
  }
}

class ScreenTimeScreen extends StatefulWidget {
  @override
  State<ScreenTimeScreen> createState() => _ScreenTimeScreenState();
}

class _ScreenTimeScreenState extends State<ScreenTimeScreen>
    with SingleTickerProviderStateMixin {
  final ScreenTimeData data = ScreenTimeData.sample;
  late AnimationController _controller;
  late Animation<Offset> firstPosition;
  late Animation<Offset> secondPosition;
  late Animation<Offset> thirdPosition;

  late Animation<double> firstScale;
  late Animation<double> secondScale;
  late Animation<double> thirdScale;

  Animation<T> createAnimation<T>(
    T begin,
    T end,
    double start,
    double endInterval,
  ) {
    return Tween<T>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, endInterval, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    firstPosition = createAnimation(Offset(0, 3.5), Offset.zero, 0.0, 0.3);
    secondPosition = createAnimation(Offset(0, 3.5), Offset.zero, 0.0, 0.8);
    thirdPosition = createAnimation(Offset(0, 3.5), Offset.zero, 0.1, 1.0);

    firstScale = createAnimation(0.5, 1.0, 0.0, 0.3);
    secondScale = createAnimation(0.5, 1.0, 0.0, 0.8);
    thirdScale = createAnimation(0.5, 1.0, 0.1, 1.0);

    _controller.forward();
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          HeaderSection(
            userName: 'Celeste',
            profileImageUrl:
                'https://images.pexels.com/photos/1036622/pexels-photo-1036622.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
            onSettingsTap: _onSettingsTap,
            animationController: _controller,
          ),
          AnimatedEntrance(
            scale: thirdScale,
            position: thirdPosition,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.cardBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: ScreenTimeSection(data: data),
            ),
          ),
          AnimatedEntrance(
            scale: secondScale,
            position: secondPosition,
            child: FocusScoreSection(
              data: data,
            ),
          ),
          AnimatedEntrance(
            scale: firstScale,
            position: firstPosition,
            child: CustomButton(
              title: 'Start Over',
              subtitle: data.lastSessionText,
              onPressed: _onStartFocusSession,
            ),
          ),
        ],
      ),
    );
  }

  void _onSettingsTap() {
    // Handle settings tap
    print('Settings tapped');
  }

  void _onStartFocusSession() {
    // Handle focus session start
    print('Focus session started');
  }
}
