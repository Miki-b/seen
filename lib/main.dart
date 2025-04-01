import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/auth/auth_gate.dart';
import 'package:seen/auth/login_or_register.dart';
import 'package:seen/pages/home.dart';
import 'package:seen/pages/login_page.dart';
import 'package:seen/providers/appwrite_provider.dart';
import 'package:seen/themes/light_mode.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Seen',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: isAuthenticated ? const HomePage() : const LoginPage(),
    );
  }
}

