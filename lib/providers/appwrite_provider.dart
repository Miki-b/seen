import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_services.dart';

final appwriteClientProvider = Provider<Client>((ref) {
  return Client()
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject('67ea91f5000cdfff2747');
});

final appwriteAccountProvider = Provider<Account>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final phoneAuthServiceProvider = Provider<PhoneAuthService>((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return PhoneAuthService(account: account, ref: ref); // Pass ref here
});

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false); // Default: not authenticated

  void login() => state = true;  // Set authentication state to true
  void logout() => state = false; // Set authentication state to false
}

final authStateProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

final userInfoProvider = FutureProvider<User>((ref) async {
  final account = ref.watch(appwriteAccountProvider);
  final user = await account.get();
  return User(
    phoneNumber: user.phone,
    userId: user.$id,
    userName: user.name,
  );
});

// User Model
class User {
  final String userId;
  final String phoneNumber;
  final String userName;

  User({
    required this.phoneNumber,
    required this.userId,
    required this.userName,
  });
}