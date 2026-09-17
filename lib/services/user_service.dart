import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:angcla_advmobprog_longexam1/constants.dart';
import 'package:angcla_advmobprog_longexam1/models/user.dart';

class UserService {
  static const String _userKey = 'logged_in_user';

  /// Authenticates credentials against DummyJSON /user/login,
  /// saves the user session locally upon success, and returns the User model.
  Future<User> login(String username, String password) async {
    final uri = Uri.parse('$host/user/login');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username.trim(),
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final user = User.fromJson(decoded);
        await saveUser(user);
        return user;
      } else {
        throw Exception('Unexpected response format from server');
      }
    } else {
      String errorMessage = 'Login failed (${response.statusCode})';
      try {
        final dynamic errorData = jsonDecode(response.body);
        if (errorData is Map<String, dynamic> && errorData['message'] != null) {
          errorMessage = errorData['message'].toString();
        }
      } catch (_) {
        // Fallback to default message if body is not JSON
      }
      throw Exception(errorMessage);
    }
  }

  /// Persists serialized user JSON in SharedPreferences.
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);
  }

  /// Retrieves and deserializes the stored user session from SharedPreferences.
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }
    try {
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        return User.fromJson(decoded);
      }
    } catch (_) {
      // In case stored JSON is corrupted or malformed
    }
    return null;
  }

  /// Checks if a valid saved authenticated session exists locally.
  Future<bool> isLoggedIn() async {
    final user = await getSavedUser();
    return user != null &&
        user.accessToken != null &&
        user.accessToken!.isNotEmpty;
  }

  /// Logs out by clearing only the user session key, preserving unrelated preferences.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
