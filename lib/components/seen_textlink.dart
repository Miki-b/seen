import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeenTextlink extends StatelessWidget {
  String text;
  SeenTextlink({required this.text,super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline
    ),);
  }
}