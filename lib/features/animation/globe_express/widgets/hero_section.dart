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
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
              return FadeTransition(opacity: curved, child: child);
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
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
              return FadeTransition(opacity: curved, child: child);
            },
            child: Text(
              destination.name,
              key: ValueKey<String>(destination.name), // Key for AnimatedSwitcher
              style: TextStyle(
                color: Colors.white,
                fontSize: 65, // Increased font size
                fontWeight: FontWeight.w700, // Extra bold
                height: 1.1,
                letterSpacing: -3,
              ),
            ),
          ),
          SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 700),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
              return FadeTransition(opacity: curved, child: child);
            },
            child: Container(
              key: ValueKey<String>(destination.description), // Key for AnimatedSwitcher
              width: 450, // Adjusted width for description
              child: Text(
                destination.description,
                style: TextStyle(
                  color: Colors.white70,
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
                width: 50, // Slightly larger
                height: 50, // Slightly larger
                decoration: BoxDecoration(
                  color: Color(0xFFF2C94C), // Yellowish color
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.bookmark, color: Colors.white, size: 26), // Icon size
              ),
              SizedBox(width: 20),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white54, width: 1.5), // Thicker border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // More padding
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