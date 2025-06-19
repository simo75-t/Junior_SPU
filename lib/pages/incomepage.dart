import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jounior/controllers/AppController.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IncomeExpenseTabsPage extends StatefulWidget {
  const IncomeExpenseTabsPage({super.key});

  @override
  State<IncomeExpenseTabsPage> createState() => _IncomeExpenseTabsPageState();
}

class _IncomeExpenseTabsPageState extends State<IncomeExpenseTabsPage> {
  // بيانات تجريبية لكل تبويب
  final List<Map<String, dynamic>> incomeData = [
    {},
    {},
    {},
  ];

  final List<Map<String, dynamic>> expenseData = [
    {},
    {},
    {},
  ];
  Future<void> IncomeExpensePage(
    double amount,
    double date,
    String category,
    String description,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = await prefs.getString('access_token') ?? "";

    final url =
        Uri.parse('${AppController.baseUrl}/api/accounts/expenses/incomes');
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
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Expense submitted: $data");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Income و Expense
      child: Scaffold(
        appBar: AppBar(
          title: Text('Income & Expense'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Income'),
              Tab(text: 'Expense'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Income Tab
            _buildListView(incomeData, true),

            // Expense Tab
            _buildListView(expenseData, false),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> data, bool isIncome) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final item = data[index];
        final amount = item['amount'] as double;
        final category = item['category'] as String;

        return ListTile(
          leading: Icon(
            isIncome ? Icons.add_circle : Icons.remove_circle,
            color: isIncome ? Colors.green : Colors.red,
            size: 30,
          ),
          title: Text(category,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          trailing: Text(
            (isIncome ? '+' : '-') + amount.toStringAsFixed(2),
            style: TextStyle(
              color: isIncome ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
