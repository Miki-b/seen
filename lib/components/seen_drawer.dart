import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/components/seen_logo.dart';
import 'package:seen/components/seen_profile_pic_big.dart';
import 'package:seen/components/seen_textlink.dart';
import 'package:seen/pages/settings_page.dart';

import '../pages/edit_info_page.dart';
import '../providers/appwrite_provider.dart';

class SeenDrawer extends ConsumerStatefulWidget {
  const SeenDrawer({super.key});

  @override
  ConsumerState<SeenDrawer> createState() => _SeenDrawerState();
}

class _SeenDrawerState extends ConsumerState<SeenDrawer> {
  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoProvider);

    return userInfo.when(
      loading: () => const Center(child: CircularProgressIndicator()), // Show loading state
      error: (err, stack) => Center(child: Text("Error: $err")), // Handle error
      data: (user) {
        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: DrawerHeader(
                  child: Center(
                    child: Column(
                      children: [
                        SeenProfilePicBig(imagePath: "assets/no-user-Image.png"),
                        const SizedBox(height: 5),
                        Text(user?.username ?? user?.userId ?? "Unknown User"),
                        //const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditInfoPage()),
                            );
                          },
                          child: SeenTextlink(text: "Edit Profile"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 20),
                  // Home list tile
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: Text("H O M E"),
                      leading: Icon(Icons.home),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  // Settings list tile
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: Text("S E T T I N G S"),
                      leading: Icon(Icons.settings),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));
                      },
                    ),
                  ),
                  // Logout list tile
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      title: Text("L O G O U T"),
                      leading: Icon(Icons.logout),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
