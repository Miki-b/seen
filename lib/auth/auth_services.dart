import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/appwrite_provider.dart';
import 'auth_gate.dart';

class PhoneAuthService {
  final Account account;
  final Ref ref;
  String? _userId;

  PhoneAuthService({required this.account, required this.ref});

  /// **Step 1: Send OTP to Phone Number**
  Future<void> sendOtp(
      String phoneNumber, Function onSuccess, Function(String) onError) async {
    try {
      final token = await account.createPhoneToken(
        userId: ID.unique(),
        phone: phoneNumber,
      );

      _userId = token.userId;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _userId!);

      onSuccess();
    } catch (e) {
      onError("Failed to send OTP: ${e.toString()}");
    }
  }

  /// **Step 2: Verify OTP and Sign In User**
  Future<Session?> verifyOtp(String otp) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userId ??= prefs.getString('userId');

      if (_userId == null) {
        throw Exception("User ID is missing. Please request OTP again.");
      }

      // Verify OTP using updatePhoneToken (New method in Appwrite 15)
      final token = await account.updatePhoneSession(
        userId: _userId!,
        secret: otp,
      );

      ref.read(authStateProvider.notifier).state = true;

      return token;
    } catch (e) {
      print('Error verifying OTP: $e');
      return null;
    }
  }

  /// **Step 3: Logout User**
  Future<void> logout(BuildContext context) async {
    try {
      await account.deleteSession(sessionId: 'current');

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');

      ref.read(authStateProvider.notifier).logout();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthGate()),
            (route) => false,
      );

      print('User logged out successfully.');
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
