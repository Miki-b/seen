import 'package:flutter/material.dart';
Color hexToColor(String hexColor) {
  // Check if the hexColor starts with # and remove it
  hexColor = hexColor.replaceFirst('#', '');

  // Check if the length is 6 or 8
  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor; // Add alpha for RGB colors
  }

  // Convert the hex string to an int and create a Color
  return Color(int.parse(hexColor, radix: 16));
}
ThemeData lightMode= ThemeData(
    colorScheme: ColorScheme.light(
        surface: Colors.white,
        //surface: hexToColor('#DEF2EF'),
        primary: hexToColor('#3C8E85'),
        secondary: hexToColor('#3B4856'),
        tertiary: Colors.white,
        inversePrimary: hexToColor('#DEF2EF')
    )
);