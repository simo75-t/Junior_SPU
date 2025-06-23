import 'dart:convert';
import 'package:jounior/controllers/AppController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DashboardController {
  // Fetch total income from the backend
  static Future<double> getTotalIncome() async {
    final dashboardData = await fetchDashboard();
    return dashboardData?['total_incomes'] ?? 0.0;
  }

  // Fetch total expenses from the backend
  static Future<double> getTotalExpenses() async {
    final dashboardData = await fetchDashboard();
    return dashboardData?['total_expenses'] ?? 0.0;
  }

  // Fetch income categories from the backend
  static Future<Map<String, double>> getIncomeCategories() async {
    final dashboardData = await fetchDashboard();
    if (dashboardData != null) {
      final Map<String, double> incomeCategories = {};
      dashboardData['incomes_by_category']?.forEach((category, total) {
        incomeCategories[category] = total.toDouble();
      });
      return incomeCategories;
    }
    return {};
  }

  // Fetch expense categories from the backend
  static Future<Map<String, double>> getExpenseCategories() async {
    final dashboardData = await fetchDashboard();
    if (dashboardData != null) {
      final Map<String, double> expenseCategories = {};
      dashboardData['expenses_by_category']?.forEach((category, total) {
        expenseCategories[category] = total.toDouble();
      });
      return expenseCategories;
    }
    return {};
  }

  // Fetch income trend data from the backend
  static Future<Map<String, Map<String, double>>> getIncomeTrend() async {
    final dashboardData = await fetchDashboard();
    if (dashboardData != null) {
      final Map<String, Map<String, double>> incomeTrend = {};
      dashboardData['income_trend']?.forEach((date, categories) {
        final Map<String, double> categoryTotals = {};
        categories?.forEach((category, total) {
          categoryTotals[category] = total.toDouble();
        });
        incomeTrend[date] = categoryTotals;
      });
      return incomeTrend;
    }
    return {};
  }

  // Fetch expense trend data from the backend
  static Future<Map<String, Map<String, double>>> getExpenseTrend() async {
    final dashboardData = await fetchDashboard();
    if (dashboardData != null) {
      final Map<String, Map<String, double>> expenseTrend = {};
      dashboardData['expense_trend']?.forEach((date, categories) {
        final Map<String, double> categoryTotals = {};
        categories?.forEach((category, total) {
          categoryTotals[category] = total.toDouble();
        });
        expenseTrend[date] = categoryTotals;
      });
      return expenseTrend;
    }
    return {};
  }

  // Fetch the entire dashboard data
  static Future<Map<String, dynamic>?> fetchDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final url = Uri.parse('${AppController.baseUrl}/api/dashboard/');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    print("Dashboard Results ${response.body} - ${response.statusCode}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
