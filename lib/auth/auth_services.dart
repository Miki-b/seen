import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:seen/providers/appwrite_provider.dart';

final phoneAuthServiceProvider = Provider<PhoneAuthService>((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return PhoneAuthService(account: account);
});

class PhoneAuthService {
  final Account account;
  String? _userId; // Store user ID from token

  PhoneAuthService({required this.account});

  /// Step 1: Send OTP to Phone Number
  Future<void> sendOtp(String phoneNumber, Function onSuccess, Function(String) onError) async {
    try {
      final token = await account.createPhoneToken(
        userId: ID.unique(), // Create a new user ID
        phone: phoneNumber,
      );

      _userId = token.userId; // Store user ID for verification
      onSuccess();
    } catch (e) {
      onError(e.toString());
    }
  }

  /// Step 2: Verify OTP and Sign In User
  Future<Session?> verifyOtp(String otp) async {
    try {
      if (_userId == null) {
        throw Exception("User ID is missing. Please request OTP first.");
      }

      final session = await account.createSession(
        userId: _userId!,  // Use the stored user ID
        secret: otp,  // OTP from SMS
      );

      return session;
    } catch (e) {
      print('Error verifying OTP: $e');
      return null;
    }
  }
}
