import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter

class DestinationCard extends StatelessWidget {
  final String imageUrl;
  final String region;
  final String name;
  final VoidCallback onTap; // Added onTap callback
  final Key? imageKey; // For measuring position
  final bool hideImage; // Hide image while flying overlay animates
  final bool hidden; // Remove entire card from view
  final bool reserveSpaceWhenHidden; // Keep layout space when hidden

  const DestinationCard({
    Key? key,
    required this.imageUrl,
    required this.region,
    required this.name,
    required this.onTap, // Required onTap
    this.imageKey,
    this.hideImage = false,
    this.hidden = false,
    this.reserveSpaceWhenHidden = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hidden && !reserveSpaceWhenHidden) {
      return const SizedBox.shrink();
    }
    final Widget card = Container(
      width: 200,
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: hideImage
                  ? const SizedBox.shrink()
                  : Image.asset(
                      imageUrl,
                      key: imageKey,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    region,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (hidden && reserveSpaceWhenHidden) {
      return IgnorePointer(
        ignoring: true,
        child: Opacity(opacity: 0, child: card),
      );
    }

    return GestureDetector( // Wrap with GestureDetector for tap
      onTap: onTap,
      child: card,
    );
  }
}