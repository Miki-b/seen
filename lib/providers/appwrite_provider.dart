import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/Services/user_services/user_services.dart';
import '../Classes/users.dart';
import '../Services/auth/auth_services.dart';

final appwriteClientProvider = Provider<Client>((ref) {
  return Client()
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject('67d3da95002d05ad4983');
});

final appwriteAccountProvider = Provider<Account>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

final phoneAuthServiceProvider = Provider<PhoneAuthService>((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return PhoneAuthService(account: account, ref: ref); // Pass ref here
});
final EmailPasswordAuthServiceProvider = Provider<EmailPasswordAuthService>((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return EmailPasswordAuthService(account: account, ref: ref); // Pass ref here
});
class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false); // Default: not authenticated

  void login() => state = true;  // Set authentication state to true
  void logout() => state = false; // Set authentication state to false
}

final authStateProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

final appwriteDatabaseProvider = Provider<Databases>((ref) {
  final client = ref.read(appwriteClientProvider);
  return Databases(client);
});


final userInfoProvider = FutureProvider<UserModel?>((ref) async {
  final account = ref.watch(appwriteAccountProvider);
  final database = ref.read(appwriteDatabaseProvider);
  final user_service = userServices();

  try {
    // Fetch user account details
    final user = await account.get();

    // Convert Appwrite Account object to UserModel
    final userModel = UserModel(
      userId: user.$id,
      username: user.name ?? "Unknown",  // Ensure username is not null
      phoneNumber: user.phone ?? "Unknown",
      profilePic: "",  // You might need a default profile pic URL
      status: "",
      lastActive: DateTime.now(),
    );

    // Save user to database (if not already saved)
    await user_service.saveUserToDatabase(userModel, database);

    // Return user info from the database
    return await user_service.getUser(user.$id, database);
  } catch (e) {
    print("Error in userInfoProvider: $e");
    return null;
  }
});
