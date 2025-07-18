import 'package:flutter/material.dart';
import 'package:twinkly_flutter/features/animation/productivity/utils/app_usage_data.dart';

class AppIconWidget extends StatelessWidget {
  final AppUsageData appData;
  final double size;

  const AppIconWidget({
    Key? key,
    required this.appData,
    this.size = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.25),
        child: Image.asset(
          appData.assetPath,
          width: size * 0.6,
          height: size * 0.6,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to colored container with first letter
            return Center(
              child: Text(
                appData.name[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}