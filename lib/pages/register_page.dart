import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../providers/appwrite_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final void Function()? onTap;
  final void Function(String userId, String secret)? onVerificationRequested;
  const RegisterPage({super.key, required this.onTap, this.onVerificationRequested});



  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  void _registerUser() async {
    setState(() => isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final auth = ref.read(EmailPasswordAuthServiceProvider);

      // Step 1: Create a new user
      await auth.createUser(email, password);

      // Step 2: Log in the user
      await auth.createEmailSession(email: email, password: password);
      // Step 3: Send email verification
      final account = ref.read(appwriteAccountProvider);
      final verification = await account.createVerification(
        url: 'https://example.com/verify', // Replace with your actual domain
      );
      // Step 4: Navigate to verification screen
      if (widget.onVerificationRequested != null) {
        widget.onVerificationRequested!(verification.userId, verification.secret);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      // TODO: Navigate to your main page or home screen
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),

              // Logo
              SizedBox(
                height: 80,
                width: 230,
                child: Image.asset("assets/seen_logo-removebg-preview.png"),
              ),

              Text(
                "Please enter your Email",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),
              MyTextfield(labelText: "Email", controller: _emailController),

              const SizedBox(height: 5),

              MyTextfield(
                isPassword: true,
                labelText: "Password",
                controller: _passwordController,
              ),

              const SizedBox(height: 15),

              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                buttonText: "Register User",
                onTap: _registerUser,
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      " Login now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
