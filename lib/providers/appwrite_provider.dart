import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appwriteClientProvider = Provider<Client>((ref) {
  return Client()
      .setEndpoint("https://cloud.appwrite.io/v1")
      .setProject('67d3da95002d05ad4983');
});

final appwriteAccountProvider = Provider<Account>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});