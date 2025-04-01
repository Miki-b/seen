import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seen/components/seen_profile_pic_big.dart';
import '../components/seen_edit_textfield.dart';
import '../providers/appwrite_provider.dart';

class EditInfoPage extends ConsumerStatefulWidget {
  const EditInfoPage({super.key});

  @override
  ConsumerState<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends ConsumerState<EditInfoPage> {
  late TextEditingController _nameController;
  String userId = "";
  bool _isSaving = false; // Show loading indicator when saving

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final userInfoAsync = ref.watch(userInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User Information"),
        actions: [
          IconButton(
            onPressed: _isSaving ? null : _saveUserInfo,
            icon: _isSaving
                ? const CircularProgressIndicator()
                : const Icon(Icons.check, color: Colors.green),
          ),
        ],
      ),
      body: userInfoAsync.when(
        data: (user) {
          _nameController.text = user.userName;
          userId = user.userId;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SeenProfilePicBig(imagePath: "assets/no-user-Image.png"),
                const SizedBox(height: 16),
                // Editable User Name
                EditableTextField(controller: _nameController),
                const SizedBox(height: 16),
                // Non-editable Phone Number
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  controller: TextEditingController(text: user.phoneNumber),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Future<void> _saveUserInfo() async {
    setState(() => _isSaving = true);

    final account = ref.read(appwriteAccountProvider);

    try {
      await account.updateName(name: _nameController.text.trim());

      // Refresh userInfoProvider after updating
      ref.invalidate(userInfoProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User info updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update user info: $e")),
      );
    }

    setState(() => _isSaving = false);
  }

}
