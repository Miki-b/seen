import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class seenLogo extends StatelessWidget {
  const seenLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,  // Adjust width and height for a perfect circle
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,  // Makes it a circle
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,  // Border color
          width: 1,  // Thin border width
        ),
      ),
     child: Padding(
       padding: const EdgeInsets.all(10.0),
       child: Image.asset("assets/seen_Logo__standard-removebg-preview.png"),
     ),
    );
  }
}
