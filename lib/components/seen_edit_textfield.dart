import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/appwrite_provider.dart';

class EditableTextField extends ConsumerStatefulWidget {
  final TextEditingController controller;

  const EditableTextField({super.key, required this.controller});

  @override
  ConsumerState<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends ConsumerState<EditableTextField> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoProvider);

    return userInfo.when(
      loading: () => const CircularProgressIndicator(), // Show loading state
      error: (err, stack) => Text("Error: $err"), // Handle errors
      data: (user) {
        widget.controller.text = user.userName.isNotEmpty ? user.userName : user.userId;

        return TextField(
          controller: widget.controller,
          // Remove the 'enabled' property or always set it to true.
          decoration: InputDecoration(
            labelText: "Username",
            labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 16),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blueAccent),
            ),


            filled: true,
            fillColor: Colors.grey.shade100,
            suffixIcon: IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.blue),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
            ),
          ),
          style: const TextStyle(fontSize: 18, color: Colors.black),
          readOnly: !_isEditing, // This ensures the text is not editable when not in editing mode.
        );
      },
    );
  }
}
