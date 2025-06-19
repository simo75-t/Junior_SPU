// controllers/user_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jounior/controllers/AppController.dart';
import 'package:jounior/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/usermodel.dart';

class UserController {
  static User? _user;

  static User? get user => _user;

  static Future<bool> login(
      String email, String password, BuildContext context) async {
    print("Start");
    final prefs = await SharedPreferences.getInstance();

    final url = Uri.parse('${AppController.baseUrl}/api/accounts/login_user/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        String accessToken = data['access'];
        await prefs.setString('access_token', accessToken);
        print("Body Request Create $data");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
        return true; // success!
      } else {
        String errorMsg = "Login failed. Please check your credentials.";
        if (response.body.isNotEmpty) {
          final errorData = jsonDecode(response.body);
          if (errorData['detail'] != null) {
            errorMsg = errorData['detail'];
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  errorMsg + response.body + response.statusCode.toString())),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      return false;
    }
  }

  static Future<bool> registeruser(String email, String username,
      String password, String currency, BuildContext context) async {
    print("Start");

    final url = Uri.parse('${AppController.baseUrl}/api/accounts/register/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'username': username,
          'password': password,
          'cash_currency': currency,
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Body Request Create $data");
        return true; // success!
      } else {
        String errorMsg = "Login failed. Please check your credentials.";
        if (response.body.isNotEmpty) {
          final errorData = jsonDecode(response.body);
          if (errorData['detail'] != null) {
            errorMsg = errorData['detail'];
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  errorMsg + response.body + response.statusCode.toString())),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      return false;
    }
  }

  static Future<void> verifyCode(
      String email, String code, BuildContext context) async {
    final url =
        Uri.parse('${AppController.baseUrl}/api/accounts/verify-email/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'code': code,
        }),
      );
      if (response.statusCode == 200) {
        // Verification success: navigate to homepage
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Verification Success! You can now login.'),
            action: SnackBarAction(
              label: 'Login',
              textColor: Colors.white, // Or any color you like
              onPressed: () {
                // Navigate to your login page
                Navigator.pop(context);
              },
            ),
            backgroundColor: const Color.fromARGB(255, 37, 116, 78),
            duration: const Duration(seconds: 6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  static Future<void> getInfo(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = await prefs.getString('access_token') ?? "";
    final url = Uri.parse('${AppController.baseUrl}/api/accounts/profile/');
    try {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response Body $data");
        _user = User.fromJson(data);
        // return User(username: data['username'], email: data['email']);
      } else {
        // رسالة خطأ لو الداتا غلط أو البيانات غير صحيحة
        String errorMsg = "an error ouccred!";
        if (response.body.isNotEmpty) {
          final errorData = jsonDecode(response.body);
          if (errorData['detail'] != null) {
            errorMsg = errorData['detail'];
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      // معالجة أي خطأ بالشبكة أو غيره
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  static Future<void> delaccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = await prefs.getString('access_token') ?? "";
    final url = Uri.parse('${AppController.baseUrl}/api/accounts/profile/');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Response Body $data");
      } else {
        // رسالة خطأ لو الداتا غلط أو البيانات غير صحيحة
        String errorMsg = "an error ouccred!";
        if (response.body.isNotEmpty) {
          final errorData = jsonDecode(response.body);
          if (errorData['detail'] != null) {
            errorMsg = errorData['detail'];
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      // معالجة أي خطأ بالشبكة أو غيره
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static Future<void> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');
    if (refreshToken == null) return;
    final url =
        Uri.parse('${AppController.baseUrl}/api/accounts/token/refresh/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('access_token', data['access']);
      if (data['refresh'] != null)
        await prefs.setString('refresh_token', data['refresh']);
    }
  }

  static Future<bool> changePassword(
      String oldPassword, String newPassword, BuildContext context) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppController.baseUrl}/api/accounts/change-password/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password changed!')));
      return true;
    } else {
      final errorData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['detail'] ?? 'Error')));
      return false;
    }
  }

  static Future<bool> logout(BuildContext context) async {
    final token = await _getToken();
    final url = Uri.parse('${AppController.baseUrl}/api/accounts/logout/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      // Navigate out
      Navigator.of(context).pushReplacementNamed('/login');
      return true;
    } else {
      final errorData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['detail'] ?? 'Logout failed')));
      return false;
    }
  }
}
