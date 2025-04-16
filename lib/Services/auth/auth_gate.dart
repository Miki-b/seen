import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/pages/home.dart';
import 'package:seen/pages/login_page.dart';
import 'package:seen/pages/register_page.dart';
import 'package:seen/pages/Email_verifcation_page.dart'; // <-- Import this
import 'package:seen/providers/appwrite_provider.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool showLoginPage = true;

  void switchPage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  void goToVerification(BuildContext context, String userId, String secret) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => EmailVerificationPage(
          userId: userId,
          secret: secret,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(authStateProvider);

    if (isAuthenticated) {
      return const HomePage();
    } else {
      return showLoginPage
          ? LoginPage(onTap: switchPage)
          : RegisterPage(
        onTap: switchPage,
        onVerificationRequested: (userId, secret) {
          goToVerification(context, userId, secret);
        },
      );
    }
  }
}
