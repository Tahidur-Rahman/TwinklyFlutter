import 'package:flutter/material.dart';
import '../data/destination_data.dart';

class HeroSection extends StatelessWidget {
  final Destination destination;

  const HeroSection({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              destination.region,
              key: ValueKey<String>(destination.region), // Key for AnimatedSwitcher
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              destination.name,
              key: ValueKey<String>(destination.name), // Key for AnimatedSwitcher
              style: TextStyle(
                color: Colors.white,
                fontSize: 78, // Increased font size
                fontWeight: FontWeight.w900, // Extra bold
                height: 0.9,
                letterSpacing: -2,
              ),
            ),
          ),
          SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey<String>(destination.description), // Key for AnimatedSwitcher
              width: 450, // Adjusted width for description
              child: Text(
                destination.description,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Row(
            children: [
              Container(
                width: 55, // Slightly larger
                height: 55, // Slightly larger
                decoration: BoxDecoration(
                  color: Color(0xFFF2C94C), // Yellowish color
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on_outlined, color: Colors.black, size: 26), // Icon size
              ),
              SizedBox(width: 20),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white54, width: 1.5), // Thicker border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 18), // More padding
                ),
                child: Text(
                  'DISCOVER LOCATION',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}