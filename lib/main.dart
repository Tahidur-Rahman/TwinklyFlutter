import 'package:flutter/material.dart';
import 'package:twinkly_flutter/features/animation/animation_list_screen.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      // theme: ThemeData(
      //   fontFamily: 'Inter',
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: AppTheme.lightTheme,
      home: const AnimationListScreen(),
      routes: {
      },
    );
  }
}

