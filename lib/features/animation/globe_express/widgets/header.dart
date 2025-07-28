import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 20.0), // Adjusted top padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Icon(Icons.travel_explore, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'GLOBE EXPRESS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800, // Slightly bolder
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          
          // Navigation Links (for larger screens)
          Spacer(flex: 2), // More space
          _buildNavLink('HOME', true),
          _buildNavLink('HOLIDAYS'),
          _buildNavLink('DESTINATIONS'),
          _buildNavLink('FLIGHTS'),
          _buildNavLink('OFFERS'),
          _buildNavLink('CONTACTS'),
          Spacer(flex: 1), // Less space on the right
          
          // Icons
          Icon(Icons.search, color: Colors.white, size: 24),
          SizedBox(width: 20),
          Icon(Icons.person_outline, color: Colors.white, size: 24),
        ],
      ),
    );
  }

  Widget _buildNavLink(String text, [bool isActive = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0), // Increased horizontal padding
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: Color(0xFFF2C94C), // Yellow underline
            ),
        ],
      ),
    );
  }
}