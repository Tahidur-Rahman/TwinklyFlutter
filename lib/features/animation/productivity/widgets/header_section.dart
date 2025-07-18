import 'package:flutter/material.dart';
import 'package:twinkly_flutter/theme/app_theme.dart';

class HeaderSection extends StatefulWidget {
  final String userName;
  final String profileImageUrl;
  final VoidCallback? onSettingsTap;
  final AnimationController animationController; // New: Receive controller

  const HeaderSection({
    Key? key,
    required this.userName,
    required this.profileImageUrl,
    this.onSettingsTap,
    required this.animationController, // New: Required parameter
  }) : super(key: key);

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> with SingleTickerProviderStateMixin {
  // Animations for profile image
  late Animation<double> _imageScale;
  late Animation<Offset> _imagePosition; // For subtle slide

  // Animations for "Welcome back," text
  late Animation<Offset> _welcomePosition;
  late Animation<double> _welcomeOpacity;

  // Animations for "Celeste" text
  late Animation<Offset> _namePosition;
  late Animation<double> _nameOpacity;

  @override
  void initState() {
    super.initState();

    // Profile Image Animation (starts earliest)
    _imageScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.animationController, curve: Interval(0.0, 0.6, curve: Curves.easeOutBack)),
    );
    _imagePosition = Tween<Offset>(begin: Offset(-0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: widget.animationController, curve: Interval(0.0, 0.6, curve: Curves.easeOutCubic)),
    );

    // "Welcome back," text animation (starts slightly after image)
    _welcomePosition = Tween<Offset>(begin: Offset(-0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: widget.animationController, curve: Interval(0.1, 0.4, curve: Curves.easeOutCubic)),
    );
    _welcomeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.animationController, curve: Interval(0.1, 0.4, curve: Curves.easeOutCubic)),
    );

    // "Celeste" text animation (starts after "Welcome back,")
    _namePosition = Tween<Offset>(begin: Offset(-0.3, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: widget.animationController, curve: Interval(0.2, 0.6, curve: Curves.easeOutCubic)),
    );
    _nameOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.animationController, curve: Interval(0.2, 0.6, curve: Curves.easeOutCubic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      padding: EdgeInsets.fromLTRB(20, 80, 20, 20), // Adjusted top padding for status bar
      child: Row(
        children: [
          // Animated Profile Image
          ScaleTransition(
            scale: _imageScale,
            child: SlideTransition(
              position: _imagePosition,
              child: CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(widget.profileImageUrl),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated "Welcome back," text
                FadeTransition(
                  opacity: _welcomeOpacity,
                  child: SlideTransition(
                    position: _welcomePosition,
                    child: Text(
                      'Welcome back,',
                      style: AppTheme.headerSubtitleStyle,
                    ),
                  ),
                ),
                // Animated "Celeste" text
                FadeTransition(
                  opacity: _nameOpacity,
                  child: SlideTransition(
                    position: _namePosition,
                    child: Text(
                      widget.userName,
                      style: AppTheme.headerTitleStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onSettingsTap,
            child: SizedBox(
              height: 22,
              width: 22,
              child: Image.asset('assets/images/productivity/settings.png'),
            ),
          ),
        ],
      ),
    );
  }
}
