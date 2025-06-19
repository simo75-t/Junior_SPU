import 'dart:convert';

import 'package:jounior/controllers/AppController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashboardController {
  // Simulated backend data (replace with real API calls)
  static Future<Map<String, double>> getIncomeCategories() async {
    return {
      'Salary': 1000.0,
      'Freelance': 500.0,
    };
  }

  static Future<Map<String, double>> getExpenseCategories() async {
    return {
      'Food': 200.0,
      'Transport': 150.0,
      'Entertainment': 100.0,
    };
  }

  static Future<double> getTotalIncome() async {
    return 1500.0;
  }

  static Future<double> getTotalExpenses() async {
    return 450.0;
  }

  static Future<Map<String, dynamic>?> fetchDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse('${AppController.baseUrl}/api/dashboard/');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
