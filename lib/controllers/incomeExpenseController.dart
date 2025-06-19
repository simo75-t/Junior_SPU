// expense_income_controller.dart
import 'dart:convert';
import 'package:jounior/controllers/AppController.dart';
import 'package:jounior/models/categoryModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ExpenseIncomeController {
  static Future<void> createExpense(double amount, String date, String category,
      String description, bool recurence) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? "";

    final url = Uri.parse('${AppController.baseUrl}/api/expenses/expenses/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'amount': amount,
          'date': date,
          'category': category,
          'description': description,
          'is_recurring': recurence,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Expense submitted: $data");
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("An Error Occurred $e");
    }
  }

  static Future<void> createIncome(double amount, String date, String category,
      String description, bool recurence) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? "";

    final url = Uri.parse('${AppController.baseUrl}/api/expenses/incomes/');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'amount': amount,
          'date': date,
          'category': category,
          'description': description,
          'is_recurring': recurence,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Income submitted: $data");
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("An Error Occurred $e");
    }
  }

  static Future<List<String>> fetchExpenseCategories() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? "";

    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/expense-categories/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data);
      } else {
        print("Error fetching expense categories: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception fetching expense categories: $e");
      return [];
    }
  }

  static Future<List<String>> fetchIncomeCategories() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString('access_token') ?? "";

    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/income-categories/');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data);
      } else {
        print("Error fetching income categories: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception fetching income categories: $e");
      return [];
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // ---- Transactions ----
  static Future<bool> createTransaction(Map<String, dynamic> data) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/transactions/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  static Future<List<dynamic>> fetchTransactions() async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/transactions/');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return [];
    }
  }

  static Future<bool> updateTransaction(
      int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/transactions/$id/');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteTransaction(int id) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/transactions/$id/');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    return response.statusCode == 204;
  }

  // ---- Categories ----
  static Future<bool> createCategory(Map<String, dynamic> data) async {
    final token = await _getToken();
    final url = Uri.parse('${AppController.baseUrl}/api/expenses/categories/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  static Future<List<CategoryModel>> fetchCategories() async {
    final token = await _getToken();
    final url = Uri.parse('${AppController.baseUrl}/api/expenses/categories/');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((c) => CategoryModel.fromJson(c)).toList();
    } else {
      return [];
    }
  }

  static Future<bool> updateCategory(int id, Map<String, dynamic> data) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/categories/$id/');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteCategory(int id) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/categories/$id/');
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    return response.statusCode == 204;
  }

  // Set FCM token
  static Future<bool> setFcmToken(String fcmToken) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppController.baseUrl}/api/expenses/set-fcm-token/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );
    return response.statusCode == 200;
  }
}
