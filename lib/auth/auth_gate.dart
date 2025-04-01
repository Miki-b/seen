import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/auth/login_or_register.dart';
import 'package:seen/pages/home.dart';
import 'package:seen/pages/login_page.dart';
import 'package:seen/providers/appwrite_provider.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(authStateProvider);

    if (isAuthenticated) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}