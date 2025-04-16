import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/components/seen_drawer.dart';
//import 'package:seen/auth/auth_service.dart';

import '../providers/appwrite_provider.dart'; // Adjust import path as needed

class HomePage extends ConsumerWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneAuthService = ref.read(phoneAuthServiceProvider);
    //final userInfo = ref.watch(userInfoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
          onPressed: () async {
    await phoneAuthService.logout(context);
    },
      icon: const Icon(Icons.logout),

    ),

        ],
        elevation: 10,
      ),
      drawer: SeenDrawer(),
    );
  }
}