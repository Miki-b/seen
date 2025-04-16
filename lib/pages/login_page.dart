//import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/Classes/users.dart';
import 'package:seen/Services/user_services/user_services.dart';
import 'package:seen/components/my_button.dart';
import 'package:seen/components/my_textfield.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:seen/components/seen_logo.dart';
import 'package:seen/pages/home.dart';

import '../providers/appwrite_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? phoneNumber;
  bool otpSent = false;
  bool isLoading = false;
  final userServices user_service =userServices();
  //final userInfo = ref.watch(userInfoProvider);
  /// **Send OTP**
  void _sendOTP() {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid phone number.")));
      return;
    }

    setState(() => isLoading = true);

    final phoneAuthService = ref.read(phoneAuthServiceProvider);
    phoneAuthService.sendOtp(
      phoneNumber!,
          () {
        setState(() {
          otpSent = true;
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("OTP Sent Successfully")));
      },
          (String error) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $error")));
      },
    );
  }

  /// **Verify OTP**
  void _verifyOTP() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please enter OTP!")));
      return;
    }

    setState(() => isLoading = true);

    final phoneAuthService = ref.read(phoneAuthServiceProvider);
    final session = await phoneAuthService.verifyOtp(_otpController.text);

    if (session != null) {
      final database = ref.read(appwriteDatabaseProvider);
      final userInfo = await ref.read(userInfoProvider.future); // ✅ Only after session

      if (userInfo != null) {
        await user_service.saveUserToDatabase(userInfo, database);
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Phone number verified!")));
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid OTP! Please try again.")));
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
              seenLogo(),
              const SizedBox(height: 40),
              Text(
                otpSent ? "Enter OTP" : "Please enter your phone number",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              // **Phone Number Field**
              IntlPhoneField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
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
              // **OTP Field (only if OTP is sent)**
              if (otpSent)
                MyTextfield(
                  isPassword: true,
                  labelText: "OTP",
                  controller: _otpController,
                ),
              const SizedBox(height: 5),
              // **Button: Send OTP / Verify OTP**
              MyButton(
                buttonText: isLoading
                    ? "Processing..."
                    : otpSent
                    ? "Verify OTP"
                    : "Send OTP",
                onTap: isLoading ? null : (otpSent ? _verifyOTP : _sendOTP),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
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
