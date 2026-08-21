import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static Future<void> saveUser({
    required String name,
    required String email,
    String? phone,
    String? age,
    String? weight,
    String? height,
    String? gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    if (phone != null) await prefs.setString('phone', phone);
    if (age != null) await prefs.setString('age', age);
    if (weight != null) await prefs.setString('weight', weight);
    if (height != null) await prefs.setString('height', height);
    if (gender != null) await prefs.setString('gender', gender);
    await prefs.setBool('isLoggedIn', true);
  }

  static Future<Map<String, String>> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'Guest User',
      'email': prefs.getString('email') ?? 'guest@example.com',
      'phone': prefs.getString('phone') ?? '+91 XXXXX XXXXX',
      'age': prefs.getString('age') ?? '21 Years',
      'weight': prefs.getString('weight') ?? '50 kg',
      'height': prefs.getString('height') ?? '165 cm',
      'gender': prefs.getString('gender') ?? 'Female',
    };
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static init() {}
}
