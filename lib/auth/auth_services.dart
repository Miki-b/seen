import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = "";

  /// ✅ Step 1: Send OTP to Phone Number
  Future<void> verifyPhoneNumber(String phoneNumber, Function onCodeSent, Function onVerificationFailed) async {
    print(phoneNumber);
    _verificationId = ""; // Reset before sending OTP
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onVerificationFailed(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }


  /// ✅ Step 2: Verify OTP and Sign In User
  Future<UserCredential?> signInWithOTP(String otp) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      return null;
    }
  }

  /// ✅ Step 3: Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// ✅ Step 4: Check if User is Logged In
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
