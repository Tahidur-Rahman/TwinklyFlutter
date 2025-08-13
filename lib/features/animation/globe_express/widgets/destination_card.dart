import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String region;
  final String name;
  final VoidCallback onTap; // Added onTap callback

  const DestinationCard({
    Key? key,
    required this.imageUrl,
    required this.region,
    required this.name,
    required this.onTap, // Required onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrap with GestureDetector for tap
      onTap: onTap,
      child: Container(
        width: 200, // Increased width
        margin: EdgeInsets.only(right: 20), // Increased margin
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), // Slightly stronger shadow
              blurRadius: 15, // More blur
              offset: Offset(0, 8), // More offset
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              // Frosted Glass Overlay
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), // Increased blur
                  child: Container(
                    color: Colors.black.withOpacity(0.2), // Slightly more opaque
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(25.0), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      region,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15, // Slightly larger
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8), // Increased spacing
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22, // Slightly larger
                        fontWeight: FontWeight.w800, // Bolder
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}