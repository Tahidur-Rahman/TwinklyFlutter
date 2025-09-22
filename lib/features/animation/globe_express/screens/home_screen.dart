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
  int? _pendingIndex;
  bool _isFlying = false;
  Timer? _autoTimer;
  int? _hiddenCardIndex; // index in visible list to hide while flying

  // Card layout metrics used for smooth shift
  static const double _cardWidth = 200.0;
  static const double _cardSpacing = 20.0; // right margin between cards

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _flyController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      if (_isFlying) return; // avoid overlapping animations
      if (_destinationsQueue.isEmpty) return;
      _onCardTapped(0, rotateAfter: true);
    });
  }

  void _onCardTapped(int index, {bool rotateAfter = false}) {
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
      _pendingIndex = index;
      _isFlying = true;
      _hiddenCardIndex = index;
      _rectAnimation = RectTween(begin: startRect, end: endRect).animate(
        CurvedAnimation(parent: _flyController, curve: Curves.easeInOutCubic),
      );
    });

    _flyController
      ..reset()
      ..forward().whenComplete(() {
        setState(() {
          _currentDestinationIndex = _pendingIndex ?? _currentDestinationIndex;
          _pendingIndex = null;
          _isFlying = false;
          _hiddenCardIndex = null;
          if (rotateAfter) {
            _rotateQueue();
            _currentDestinationIndex = 0;
          }
        });
      });
  }

  void _rotateQueue() {
    if (_destinationsQueue.isEmpty) return;
    final first = _destinationsQueue.removeAt(0);
    _destinationsQueue.add(first);
    final firstKey = _cardImageKeys.removeAt(0);
    _cardImageKeys.add(firstKey);
  }

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
          // Background Image (switches after fly animation completes)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey<String>(_destinationsQueue[_currentDestinationIndex].imageUrl), // Key for AnimatedSwitcher
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_destinationsQueue[_currentDestinationIndex].imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
             
            ),
          ),

          // Flying overlay image from tapped card to background
          if (_isFlying && _rectAnimation != null)
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
                              image: AssetImage(_destinationsQueue[_pendingIndex!].imageUrl),
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
                      child: HeroSection(destination: _destinationsQueue[_currentDestinationIndex]), // Pass current destination
                    ),
                    Expanded(
                      flex: 7, // Adjusted flex for card list
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 320, // Increased height for the horizontal card list
                            child: AnimatedBuilder(
                              animation: _flyController,
                              builder: (context, child) {
                                final bool shiftingFirst = _isFlying && _hiddenCardIndex == 0;
                                final double dx = shiftingFirst
                                    ? -(_cardWidth + _cardSpacing) * _flyController.value
                                    : 0.0;
                                return Transform.translate(
                                  offset: Offset(dx, 0),
                                  child: child,
                                );
                              },
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(right: 40, bottom: 20),
                                itemCount: _destinationsQueue.length,
                                itemBuilder: (context, index) {
                                  return DestinationCard(
                                    imageUrl: _destinationsQueue[index].imageUrl,
                                    region: _destinationsQueue[index].region,
                                    name: _destinationsQueue[index].name,
                                    onTap: () => _onCardTapped(index), // Pass onTap callback
                                    imageKey: _cardImageKeys[index],
                                    hideImage: _isFlying && _pendingIndex == index,
                                  hidden: _hiddenCardIndex == index,
                                  reserveSpaceWhenHidden: true,
                                  );
                                },
                              ),
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
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0, 0.5),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '0${_currentDestinationIndex + 1}', // Update page number
                                    key: ValueKey<int>(_currentDestinationIndex), // Key for AnimatedSwitcher
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28, // Increased font size
                                      fontWeight: FontWeight.w800, // Bolder
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
}