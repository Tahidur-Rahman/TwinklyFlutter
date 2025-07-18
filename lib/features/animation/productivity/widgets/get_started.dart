import 'package:flutter/material.dart';
import 'package:twinkly_flutter/features/animation/productivity/home_page.dart';
import 'package:twinkly_flutter/features/animation/productivity/utils/CustomPageRouteBuilder.dart';

class GetStartedButton extends StatefulWidget {
  const GetStartedButton({super.key});

  @override
  State<GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() async {
    await _controller.forward();
    await _controller.reverse();
    Navigator.of(context).push(
      CustomPageRouteBuilder(route: ScreenTimeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: SizedBox(
        height: 65,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            side: const BorderSide(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(width: 100),
              Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 100),
              Icon(
                Icons.chevron_right,
                color: Colors.black,
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



