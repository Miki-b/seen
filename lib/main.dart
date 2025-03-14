import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/auth/login_or_register.dart';
import 'package:seen/themes/light_mode.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seen',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const LoginorRegister(),
    );
  }
}