import 'package:flutter/material.dart';

class SeenProfilePicBig extends StatelessWidget {
  final String imagePath; // Changed to `final` for immutability

  SeenProfilePicBig({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,  // Adjust width and height for a perfect circle
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover, // Ensures the image covers the whole area
          width: 80, // Match container size
          height: 80,
        ),
      ),
    );
  }
}
