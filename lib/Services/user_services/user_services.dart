import 'package:appwrite/appwrite.dart';

import '../../Classes/users.dart';

class userServices {
  Future<void> saveUserToDatabase(UserModel user, Databases database) async {
    try {
      await database.createDocument(
        databaseId: '67ebd642001481fe0d65',
        collectionId: '67ebd64c002671a92141',
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
        databaseId: '67ebd642001481fe0d65',
        collectionId: '67ebd64c002671a92141',
        documentId: userId,
      );

      return UserModel.fromJson(document.data);  // ✅ Convert JSON to Dart object
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
}