import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; // For BackdropFilter
import 'dart:async';

import '../widgets/header.dart';
import '../widgets/hero_section.dart';
import '../widgets/destination_card.dart';
import '../data/destination_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _currentDestinationIndex = 0; // Active index in queue (always 0 after rotations)
  int _currentPage = 1; // 1-based page number for display

  // Mutable queue for infinite carousel behavior
  late List<Destination> _destinationsQueue = List<Destination>.from(destinations);

  // Keys to locate each card's image on screen
  late List<GlobalKey> _cardImageKeys =
      List<GlobalKey>.generate(_destinationsQueue.length, (_) => GlobalKey());

  // Fly-to-background animation state
  late final AnimationController _flyController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  );

  Animation<Rect?>? _rectAnimation;
  Destination? _flyingDestination; // item animating to background
  int? _flyingIndex; // index of the card animating
  bool _isFlying = false;
  Timer? _autoTimer;
  // no pending page tracking needed
  Destination? _backgroundDestination; // what the background should currently display
  bool _bgUpdateDone = false; // ensure bg updates once near end of flight
  VoidCallback? _flyProgressListener; // to detach listener after flight

  // Card layout metrics used for smooth shift
  static const double _cardWidth = 200.0;
  static const double _cardSpacing = 20.0; // right margin between cards
  final ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _backgroundDestination = _destinationsQueue[_currentDestinationIndex];
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _flyController.dispose();
    _listController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      if (_isFlying) return; // avoid overlapping animations
      if (_destinationsQueue.isEmpty) return;
      _onCardTapped(0);
    });
  }

  void _onCardTapped(int index) {
    // Compute the starting rect of the tapped card image in global coordinates
    final key = _cardImageKeys[index];
    final contextOfImage = key.currentContext;
    if (contextOfImage == null) {
      // Fallback if layout not ready – just switch instantly
      setState(() => _currentDestinationIndex = index);
      return;
    }

    final renderBox = contextOfImage.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      setState(() => _currentDestinationIndex = index);
      return;
    }

    final Offset globalTopLeft = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final Rect startRect = globalTopLeft & size;

    // Target is full screen background area
    final Size screenSize = MediaQuery.of(context).size;
    final Rect endRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);

    setState(() {
      // Capture the flying item; keep queue order until animation completes
      _flyingDestination = _destinationsQueue[index];
      _flyingIndex = index;
      // Keep current background until the flight finishes
      _isFlying = true;
      _rectAnimation = RectTween(begin: startRect, end: endRect).animate(
        CurvedAnimation(parent: _flyController, curve: Curves.easeInOutCubic),
      );
    });

    // Schedule background switch slightly before completion to avoid visible pop
    _bgUpdateDone = false;
    _flyProgressListener ??= () {
      final double v = _flyController.value;
      if (!_bgUpdateDone && v >= 0.6 && _flyingDestination != null) {
        setState(() {
          _backgroundDestination = _flyingDestination;
        });
        _bgUpdateDone = true;
      }
    };
    _flyController.addListener(_flyProgressListener!);

    // Smooth left slide: animate list from 0 -> shift, then reset to 0 after rotation
    final double shift = _cardWidth + _cardSpacing;
    if (_listController.hasClients) {
      try {
        _listController.jumpTo(0);
        _listController.animateTo(
          shift,
          duration: _flyController.duration ?? const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      } catch (_) {}
    }

    _flyController
      ..reset()
      ..forward().whenComplete(() {
        // Rotate queue now that animation finished
        setState(() {
          if (_destinationsQueue.isNotEmpty) {
            final first = _destinationsQueue.removeAt(0);
            _destinationsQueue.add(first);
            final firstKey = _cardImageKeys.removeAt(0);
            _cardImageKeys.add(firstKey);
            _currentDestinationIndex = 0;
            _currentPage = (_currentPage % _destinationsQueue.length) + 1;
          }
          // Now that the flight has completed, update the background to the flown item
          if (_flyingDestination != null) {
            _backgroundDestination = _flyingDestination;
          }
          _isFlying = false;
          _flyingDestination = null;
          _flyingIndex = null;
          _bgUpdateDone = false;
          if (_flyProgressListener != null) {
            _flyController.removeListener(_flyProgressListener!);
            _flyProgressListener = null;
          }
        });
        // Reset scroll position back to 0 instantly to prepare for next cycle
        if (_listController.hasClients) {
          try {
            _listController.jumpTo(0);
          } catch (_) {}
        }
      });
  }

  // immediate rotation handled in _onCardTapped

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style for transparent status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: Stack(
        children: [
          // Background Image (shows the last flying item until the next flight)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey<String>(
                (_backgroundDestination ?? _destinationsQueue[_currentDestinationIndex]).imageUrl,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    (_backgroundDestination ?? _destinationsQueue[_currentDestinationIndex]).imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Flying overlay image from tapped card to background
          if (_isFlying && _rectAnimation != null && _flyingDestination != null)
            AnimatedBuilder(
              animation: _flyController,
              builder: (context, child) {
                final rect = _rectAnimation!.value!;
                final t = _flyController.value;
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
                              image: AssetImage(_flyingDestination!.imageUrl),
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
            ),

          // Overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              Header(), // Top navigation bar
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5, // Adjusted flex for hero section
                      child: AnimatedBuilder(
                        animation: _flyController,
                        builder: (context, child) {
                          final bool fading = _isFlying;
                          final double t = _flyController.value;
                          final double opacity = fading ? (1.0 - t) : 1.0;
                          return Opacity(
                            opacity: opacity,
                            child: child,
                          );
                        },
                        child: HeroSection(destination: _destinationsQueue[_currentDestinationIndex]),
                      ),
                    ),
                    Expanded(
                      flex: 7, // Adjusted flex for card list
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 320, // Increased height for the horizontal card list
                            child: ListView.builder(
                              controller: _listController,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(right: 40, bottom: 20),
                              itemCount: _destinationsQueue.length,
                              itemBuilder: (context, index) {
                                final bool isPlaceholder = _isFlying && _flyingIndex == index;
                                return DestinationCard(
                                  imageUrl: _destinationsQueue[index].imageUrl,
                                  region: _destinationsQueue[index].region,
                                  name: _destinationsQueue[index].name,
                                  onTap: () => _onCardTapped(index), // Pass onTap callback
                                  imageKey: _cardImageKeys[index],
                                  hideImage: false,
                                  hidden: isPlaceholder,
                                  reserveSpaceWhenHidden: true,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 40.0, bottom: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    _buildNavigationArrow(Icons.chevron_left),
                                    SizedBox(width: 20), // Increased spacing
                                    _buildNavigationArrow(Icons.chevron_right),
                                  ],
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 350),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    _formatPage(_currentPage),
                                    key: ValueKey<int>(_currentPage),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationArrow(IconData icon) {
    return Container(
      width: 55, // Slightly larger
      height: 55, // Slightly larger
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white54, width: 1.5), // Thicker border
      ),
      child: Icon(icon, color: Colors.white, size: 30), // Larger icon
    );
  }

  String _formatPage(int page) {
    if (page < 10) return '0$page';
    return '$page';
  }
}