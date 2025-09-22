import 'package:flutter/material.dart';
import 'dart:ui';

class FlyingOverlay extends StatelessWidget {
  final AnimationController controller;
  final Animation<Rect?> rectAnimation;
  final String imageUrl;

  const FlyingOverlay({
    Key? key,
    required this.controller,
    required this.rectAnimation,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final rect = rectAnimation.value!;
        final t = controller.value;
        final borderRadius = BorderRadius.lerp(
          BorderRadius.circular(22),
          BorderRadius.zero,
          t,
        )!;
        final double blur = lerpDouble(2.5, 0, t)!;
        final double shadowBlur = lerpDouble(12, 0, t)!;
        final double shadowDy = lerpDouble(8, 0, t)!;
        return Positioned(
          left: rect.left,
          top: rect.top,
          width: rect.width,
          height: rect.height,
          child: IgnorePointer(
            ignoring: true,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25 * (1 - t)),
                        blurRadius: shadowBlur,
                        offset: Offset(0, shadowDy),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


