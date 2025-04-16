import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:seen/providers/appwrite_provider.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  final String userId;
  final String secret;

  const EmailVerificationPage({
    super.key,
    required this.userId,
    required this.secret,
  });

  @override
  ConsumerState<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  bool isVerifying = true;
  String message = "";

  @override
  void initState() {
    super.initState();
    _verifyEmail();
  }

  Future<void> _verifyEmail() async {
    final account = ref.read(appwriteAccountProvider);

    try {
      await account.updateVerification(
        userId: widget.userId,
        secret: widget.secret,
      );

      setState(() {
        isVerifying = false;
        message = "Your email has been successfully verified! You can now log in.";
      });
    } catch (e) {
      setState(() {
        isVerifying = false;
        message = "Verification failed. Please try again or contact support.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: isVerifying
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
