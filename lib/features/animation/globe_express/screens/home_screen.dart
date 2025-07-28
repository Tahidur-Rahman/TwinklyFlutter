import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; // For BackdropFilter

import '../widgets/header.dart';
import '../widgets/hero_section.dart';
import '../widgets/destination_card.dart';
import '../data/destination_data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentDestinationIndex = 0; // Start with the first destination (Alps)

  void _onCardTapped(int index) {
    setState(() {
      _currentDestinationIndex = index;
    });
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
          // Animated Background Image
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800), // Animation duration
            transitionBuilder: (Widget child, Animation<double> animation) {
              // Custom transition for background image
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: Container(
              key: ValueKey<String>(destinations[_currentDestinationIndex].imageUrl), // Key for AnimatedSwitcher
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(destinations[_currentDestinationIndex].imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              // Optional: Add a subtle blur during transition for effect
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0), // Adjust blur as needed
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Overlay for text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
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
                      flex: 3, // Adjusted flex for hero section
                      child: HeroSection(destination: destinations[_currentDestinationIndex]), // Pass current destination
                    ),
                    Expanded(
                      flex: 2, // Adjusted flex for card list
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 350, // Increased height for the horizontal card list
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(right: 40, bottom: 20),
                              itemCount: destinations.length,
                              itemBuilder: (context, index) {
                                return DestinationCard(
                                  imageUrl: destinations[index].imageUrl,
                                  region: destinations[index].region,
                                  name: destinations[index].name,
                                  onTap: () => _onCardTapped(index), // Pass onTap callback
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