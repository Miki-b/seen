import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPService {
  static const String baseUrl = "http://seen.42web.io/contact.php"; // Update this with the correct backend URL

  // Function to send OTP
  static Future<Map<String, dynamic>> sendOTP(String phone) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "send", "phone": phone}),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"success": false, "message": "Failed to send OTP. Server error."};
      }
    } catch (e) {
      print("Error sending OTP: $e");
      return {"success": false, "message": "Failed to send OTP"};
    }
  }

  // Function to verify OTP
  static Future<Map<String, dynamic>> verifyOTP(String phone, String code) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "verify", "phone": phone, "code": code}),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"success": false, "message": "Failed to verify OTP. Server error."};
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return {"success": false, "message": "Failed to verify OTP"};
    }
  }
}
