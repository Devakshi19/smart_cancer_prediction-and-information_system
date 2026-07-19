// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // --- IMPORTANT: UPDATE THIS IP ADDRESS ---
  // Use your computer's local IP address (e.g., 192.168.1.100).
  // Do NOT use 'localhost' or '127.0.0.1' when testing on Android emulators.
  static const String baseUrl = "http://192.168.31.51/cancer_api";

  // Function for User Signup
  static Future<Map<String, dynamic>> signup(
      String username, String email, String password) async {
    final url = Uri.parse("$baseUrl/signup.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "email": email,
          "password": password,
        }),
      );

      print("Signup Response Status: ${response.statusCode}");
      print("Signup Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          "success": false,
          "message": "Server Error: ${response.statusCode}"
        };
      }
    } catch (e) {
      print("Signup Error: $e");
      return {"success": false, "message": "Connection Error: $e"};
    }
  }

  // Function for User Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse("$baseUrl/login.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      print("Login Response Status: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          "success": false,
          "message": "Server Error: ${response.statusCode}"
        };
      }
    } catch (e) {
      print("Login Error: $e");
      return {"success": false, "message": "Connection Error: $e"};
    }
  }
}
