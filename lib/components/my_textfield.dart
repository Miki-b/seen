import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  final bool isPassword;
  final String labelText;
  final TextEditingController controller;

  const MyTextfield({super.key, this.isPassword = false, required this.labelText,required this.controller});

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  bool _obscureText = true; // This should be an instance variable

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Add this line
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
      cursorColor: Theme.of(context).colorScheme.primary,
      style: const TextStyle(fontSize: 18, color: Colors.black),
    );

  }
}
