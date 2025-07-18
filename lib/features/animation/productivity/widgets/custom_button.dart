import 'package:flutter/material.dart';
import 'package:twinkly_flutter/features/animation/productivity/productivity.dart';
import 'package:twinkly_flutter/features/animation/productivity/utils/CustomPageRouteBuilder.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsets? padding;

  const CustomButton({
    Key? key,
    required this.title,
    this.subtitle,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
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
      CustomPageRouteBuilder(route: Productivity()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          onPressed:_onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor ?? AppTheme.focusButtonColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 100),
            ),
            padding: widget.padding ?? EdgeInsets.symmetric(vertical: 18),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: AppTheme.buttonTextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
              if (widget.subtitle != null) ...[
                SizedBox(height: 2),
                Text(
                  widget.subtitle!,
                  style: AppTheme.buttonSubtextStyle.copyWith(
                    color: (widget.textColor ?? Colors.black).withOpacity(0.8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}