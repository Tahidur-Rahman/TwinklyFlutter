import 'package:flutter/services.dart';

class AppUsageData {
  final String name;
  final String assetPath;
  final Color backgroundColor;

  const AppUsageData({
    required this.name,
    required this.assetPath,
    required this.backgroundColor,
  });
}

class ScreenTimeData {
  final String todayTime;
  final String lastHourTime;
  final int phonePickups;
  final double focusScore;
  final String focusRating;
  final List<AppUsageData> mostUsedApps;
  final String achievementText;
  final String lastSessionText;

  const ScreenTimeData({
    required this.todayTime,
    required this.lastHourTime,
    required this.phonePickups,
    required this.focusScore,
    required this.focusRating,
    required this.mostUsedApps,
    required this.achievementText,
    required this.lastSessionText,
  });

  static const ScreenTimeData sample = ScreenTimeData(
    todayTime: '2:43',
    lastHourTime: '0:12',
    phonePickups: 23,
    focusScore: 8.5,
    focusRating: 'Good',
    mostUsedApps: [
      AppUsageData(
        name: 'Messages',
        assetPath: 'assets/images/productivity/1.png',
        backgroundColor: Color(0xFF007AFF),
      ),
      AppUsageData(
        name: 'WhatsApp',
        assetPath: 'assets/images/productivity/2.png',
        backgroundColor: Color(0xFF25D366),
      ),
      AppUsageData(
        name: 'Instagram',
        assetPath: 'assets/images/productivity/3.png',
        backgroundColor: Color(0xFFE4405F),
      ),
      AppUsageData(
        name: 'Health',
        assetPath: 'assets/images/productivity/4.png',
        backgroundColor: Color(0xFFE91E63),
      ),
      AppUsageData(
        name: 'YouTube',
        assetPath: 'assets/images/productivity/5.png',
        backgroundColor: Color(0xFFFF0000),
      ),
    ],
    achievementText: 'Way to go! Your screen time this week is 7% less than last week',
    lastSessionText: 'Last session: 2 hours ago',
  );
}