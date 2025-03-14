import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../auth/phone_auth.dart'; // Ensure this path matches your project structure
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? phoneNumber;
  bool otpSent = false;
  bool isLoading = false;

  // Function to send OTP
  void _sendOTP() async {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number.")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await OTPService.sendOTP(phoneNumber!);

      if (response["success"] == true) {
        setState(() {
          otpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP Sent Successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Failed to send OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }

    setState(() => isLoading = false);
  }

  // Function to verify OTP
  void _verifyOTP() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter OTP!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await OTPService.verifyOTP(phoneNumber!, _otpController.text);

      if (response["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Phone number verified!")),
        );
        // Navigate to next screen (e.g., Home Page)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Invalid OTP! Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }

    setState(() => isLoading = false);
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

              // OTP field
              otpSent
                  ? MyTextfield(
                isPassword: true,
                labelText: "OTP",
                controller: _otpController,
              )
                  : Container(),

              const SizedBox(height: 15),

              // Loading indicator
              if (isLoading)
                const CircularProgressIndicator()
              else
                MyButton(
                  buttonText: otpSent ? "Verify OTP" : "Send OTP",
                  onTap: otpSent ? _verifyOTP : _sendOTP,
                ),

              const SizedBox(height: 15),

              // Already have an account? Login
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
