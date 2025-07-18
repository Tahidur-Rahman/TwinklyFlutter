import 'package:flutter/material.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool secondary;

  const StatItem({
    Key? key,
    required this.value,
    required this.label,
     this.secondary = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTheme.largeNumberStyle.copyWith(fontSize: secondary?22:40),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.smallTextStyle,
          ),
        ],
      ),
    );
  }
}