import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:twinkly_flutter/features/animation/productivity/utils/app_usage_data.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/app_icon_widget.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';

class FocusScoreSection extends StatelessWidget {
  final ScreenTimeData data;

  const FocusScoreSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -35),
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.focusCardBackgroundColor,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FOCUS SCORE',
              style: AppTheme.sectionHeaderStyle,
            ),
            SizedBox(height: 24),
            _buildScoreAndApps(),
            SizedBox(height: 25),
            _buildAchievement(),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreAndApps() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    data.focusScore.toString(),
                    style: AppTheme.largeNumberStyle,
                  ),
                  SizedBox(height: 40,width: 40,child: Image.asset('assets/images/productivity/star-small.png')),
                ],
              ),
              SizedBox(height: 4),
              Text(
                data.focusRating,
                style: AppTheme.smallTextStyle,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: data.mostUsedApps
                  .map((app) => AppIconWidget(appData: app))
                  .toList(),
            ),
            SizedBox(height: 8),
            Text(
              'Most used',
              style: AppTheme.smallTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryTextColor, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.trending_up,
              size: 18,
              color: AppTheme.primaryTextColor,
            ),
          ),
          SizedBox(width: 30),
          Expanded(
            child: Text(
              data.achievementText,
              style: AppTheme.mediumTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
