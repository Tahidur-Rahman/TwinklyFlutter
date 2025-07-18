import 'package:flutter/material.dart';
import 'package:twinkly_flutter/features/animation/productivity/utils/app_usage_data.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/animated_wave_chart.dart';
import 'package:twinkly_flutter/features/animation/productivity/widgets/stat_item.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';

class ScreenTimeSection extends StatelessWidget {
  final ScreenTimeData data;

  const ScreenTimeSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
          _buildHeader(),
          SizedBox(height: 15),
          _buildStats(),
          SizedBox(height: 10),
          
            ],
          ),
        ),
        AnimatedWaveChart(height: 130),
        _buildTimeLabels(),
        SizedBox(height: 60),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'SCREEN TIME',
          style: AppTheme.sectionHeaderStyle,
        ),
        Spacer(),
        Container(
          height: 35,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppTheme.borderColor, width: 1),
          ),
          child: Text(
            'Thu, June 20',
            style: AppTheme.smallTextStyle.copyWith(
              color: AppTheme.primaryTextColor,
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: AppTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(44),
            border: Border.all(color: AppTheme.borderColor, width: 1),
          ),
          child: Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: AppTheme.primaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        StatItem(
          value: data.todayTime,
          label: 'Today',
        ),
        StatItem(
          value: data.lastHourTime,
          label: 'Last hour',
          secondary: true,
        ),
        StatItem(
          value: data.phonePickups.toString(),
          label: 'Phone pickups',
          secondary: true,
        ),
      ],
    );
  }

  Widget _buildTimeLabels() {
    final timeLabels = ['AM', '10 AM', '12 PM', '2 PM', '4 PM', '6 PM', '8 PM'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: timeLabels.map((time) => Text(
        time,
        style: TextStyle(
          fontSize: 13,
          color: AppTheme.secondaryTextColor,
          fontWeight: FontWeight.w500,
          letterSpacing: -.4
        ),
      )).toList(),
    );
  }
}