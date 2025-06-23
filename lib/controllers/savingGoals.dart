import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jounior/controllers/AppController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavingGoalController {
  // Fetch financial goals with authentication
  static Future<List<SavingGoal>> fetchSavingGoals() async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken =
        prefs.getString('access_token') ?? ""; // Get access token

    final response = await http.get(
      Uri.parse('${AppController.baseUrl}/api/FinancialGoals/saving-goals/'),
      headers: <String, String>{
        'Authorization': 'Bearer $accessToken', // Add token to header
      },
    );

    print("Saving Goals ${response.body} - ${response.statusCode}");
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print(
          "Success Reading Saving Goals ${response.body} - ${response.statusCode}");
      List<dynamic> data = json.decode(response.body);
      return data.map((goalJson) => SavingGoal.fromJson(goalJson)).toList();
    } else {
      throw Exception('Failed to load goals');
    }
  }

  // Create a new saving goal with authentication
// Create a new saving goal with authentication
  static Future<SavingGoal> createSavingGoal(SavingGoal goal) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken =
        prefs.getString('access_token') ?? ""; // Get access token

    try {
      final response = await http.post(
        Uri.parse('${AppController.baseUrl}/api/FinancialGoals/saving-goals/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token to header
        },
        body: json.encode(goal.toJson()),
      );

      print(
          "Creating Saving Goals Response: ${response.body} - ${response.statusCode}");

      // Handle a broader range of success status codes (200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parsing the JSON response to SavingGoal
        return SavingGoal.fromJson(json.decode(response.body));
      } else {
        // Log error response if not successful
        print("Error creating saving goal: ${response.body}");
        throw Exception('Failed to create goal');
      }
    } catch (e) {
      // Catch any exceptions and log them
      print("Error in createSavingGoal: $e");
      throw Exception('Error creating goal');
    }
  }

  // Update an existing saving goal with authentication
  static Future<SavingGoal> updateSavingGoal(
      int goalId, SavingGoal goal) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken =
        prefs.getString('access_token') ?? ""; // Get access token

    try {
      final response = await http.put(
        Uri.parse(
            '${AppController.baseUrl}/api/FinancialGoals/saving-goals/$goalId/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token to header
        },
        body: json.encode(goal.toJson()),
      );

      print(
          "Updating Saving Goal Response: ${response.body} - ${response.statusCode}");

      // Handle a broader range of success status codes (200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Successfully updated, return the updated goal
        return SavingGoal.fromJson(json.decode(response.body));
      } else {
        // Log error response if not successful
        print("Error updating saving goal: ${response.body}");
        throw Exception('Failed to update goal');
      }
    } catch (e) {
      // Catch any exceptions and log them
      print("Error in updateSavingGoal: $e");
      throw Exception('Error updating goal');
    }
  }

  // Delete a saving goal with authentication
  static Future<void> deleteSavingGoal(int goalId) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken =
        prefs.getString('access_token') ?? ""; // Get access token

    final response = await http.delete(
      Uri.parse(
          '${AppController.baseUrl}/api/FinancialGoals/saving-goals/$goalId/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken', // Add token to header
      },
    );

    print(
        "Deleting Saving Goal Response: ${response.body} - ${response.statusCode}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Successfully deleted
      print("Successfully deleted saving goal with ID: $goalId");
    } else {
      print("Error deleting saving goal: ${response.body}");
      throw Exception('Failed to delete goal');
    }
  }
}

class SavingGoal {
  final int id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  DateTime? deadline;
  final bool isAchieved;

  SavingGoal({
    this.id = 0,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    this.deadline,
    this.isAchieved = false,
  });

  // To convert from JSON to Dart object
  factory SavingGoal.fromJson(Map<String, dynamic> json) {
    return SavingGoal(
      id: json['id'],
      title: json['title'],
      targetAmount: json['target_amount'] != null
          ? double.tryParse(json['target_amount'].toString()) ?? 0.0
          : 0.0,
      currentAmount: json['current_amount'] != null
          ? double.tryParse(json['current_amount'].toString()) ?? 0.0
          : 0.0,
      deadline: json['deadline'] != null
          ? DateFormat('yyyy-MM-dd').parse(json['deadline'])
          : null,
      isAchieved: json['is_achieved'] ?? false,
    );
  }

  // To convert Dart object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      // Ensure deadline is formatted correctly before sending it
      'deadline':
          deadline != null ? deadline!.toIso8601String().split('T')[0] : null,
      'is_achieved': isAchieved,
    };
  }
}
