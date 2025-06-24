import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'AppController.dart'; // Assuming you already have this controller

class UpdatePasswordController {
  // Update password method with two new password fields
  static Future<bool> changePassword(String oldPassword, String newPassword,
      String confirmPassword, BuildContext context) async {
    // Check if the new passwords match
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final url = Uri.parse('${AppController.baseUrl}/api/change_password/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      }),
    );

    // Debugging: Print the raw response body for debugging
    print("Response body: ${response.body}");

    // Check for HTML response (e.g., if the server is redirecting to a login page or error page)
    if (response.body.startsWith('<!DOCTYPE html>')) {
      // Handle HTML response (possibly a login page or error page)
      print("HTML response: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Unexpected error occurred. Please try again later.')),
      );
      return false;
    }

    if (response.statusCode == 200) {
      // Password update successful
      return true;
    } else {
      // Password update failed (error message from backend can be retrieved)
      try {
        final responseData = jsonDecode(response.body);
        final errorMessage = responseData['detail'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        // If the response is not valid JSON, print it for debugging
        print("Failed to parse response: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to update password. Please try again.')),
        );
      }
      return false;
    }
  }
}
