import 'dart:convert';

import 'package:appwrite/appwrite.dart';

class UserModel {
  final String userId;
  final String username;
  final String phoneNumber;
  final String profilePic;
  final String status;
  final DateTime lastActive;

  UserModel({
    required this.userId,
    required this.username,
    required this.phoneNumber,
    required this.profilePic,
    required this.status,
    required this.lastActive,
  });

  /// Convert Dart object to JSON (for storing in database)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'status': status,
      'lastActive': lastActive.toIso8601String(),
    };
  }

  /// Convert JSON from database to Dart object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      profilePic: json['profilePic'],
      status: json['status'],
      lastActive: DateTime.parse(json['lastActive']),
    );
  }
  Future<void> saveUserToDatabase(UserModel user, Databases database) async {
    try {
      await database.createDocument(
        databaseId: 'your_database_id',
        collectionId: 'users',
        documentId: user.userId,
        data: user.toJson(),
      );
      print("User saved successfully!");
    } catch (e) {
      print("Error saving user: $e");
    }
  }

  Future<UserModel?> getUser(String userId, Databases database) async {
    try {
      final document = await database.getDocument(
        databaseId: 'your_database_id',
        collectionId: 'users',
        documentId: userId,
      );

      return UserModel.fromJson(document.data);  // ✅ Convert JSON to Dart object
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }


}
