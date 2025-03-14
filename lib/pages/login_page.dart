import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:seen/auth/auth_services.dart';
import 'package:seen/components/my_button.dart';
import 'package:seen/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap; // Corrected declaration

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? phoneNumber;
  final PhoneAuthService _phoneAuthService = PhoneAuthService();
  bool otpSent = false;

  void _sendOTP() {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      print(phoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid phone number.")),

      );
      return;
    }

    _phoneAuthService.verifyPhoneNumber(
      phoneNumber!, // Use the formatted number
          () {
        setState(() {
          otpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP Sent Successfully")));
      },
          (String error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $error")));
      },
    );
  }


  void _verifyOTP() async {
    print("Entered OTP: ${_otpController.text}");
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter OTP!")));
      return;
    }

    UserCredential? userCredential = await _phoneAuthService.signInWithOTP(_otpController.text);

    if (userCredential != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone number verified!")));
      // Navigate to home page or dashboard
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP! Please try again.")));
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

              // Welcome message
              Text(
                "Welcome back, you have been missed",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              Text(
                "Please enter your country phone number",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 16),

              // Phone number field
              IntlPhoneField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
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
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                initialCountryCode: 'ET', // Ethiopia
                onChanged: (phone) {
                  setState(() {
                    phoneNumber = phone.completeNumber.trim();
                  });
                },
              ),

              const SizedBox(height: 5),

              // Password field
              otpSent
                  ?MyTextfield(
                isPassword: true,
                labelText: "OTP",
                controller: _otpController,
              ):Container(),

              const SizedBox(height: 15),

              // Login button
              MyButton(buttonText: otpSent ? "Verify OTP" : "Send OTP", onTap: otpSent ? _verifyOTP : _sendOTP),

              const SizedBox(height: 15),

              // Register Now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap, // Correct usage
                    child: Text(
                      " Register now",
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
