import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FinancialGoalsScreen extends StatefulWidget {
  @override
  _FinancialGoalsScreenState createState() => _FinancialGoalsScreenState();
}

class _FinancialGoalsScreenState extends State<FinancialGoalsScreen> {
  List<FinancialGoal> goals = [
    FinancialGoal(
      title: 'Buy a Laptop',
      targetAmount: 5000,
      savedAmount: 2500,
      dueDate: DateTime(2025, 9, 1),
    ),
    FinancialGoal(
      title: 'Vacation Trip',
      targetAmount: 8000,
      savedAmount: 3000,
      dueDate: DateTime(2025, 12, 15),
    ),
    FinancialGoal(
      title: 'Upgrade Phone',
      targetAmount: 3000,
      savedAmount: 1000,
      dueDate: DateTime(2025, 7, 10),
    ),
  ];

  void _deleteGoal(int index) {
    setState(() {
      goals.removeAt(index);
    });
  }

  void _editGoal(int index) {
    final goal = goals[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Goal'),
        content:
            Text('Edit screen for "${goal.title}" will be implemented later.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Financial Goals',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 100, 181, 100),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          final percent = goal.savedAmount / goal.targetAmount;
          final formattedDate = DateFormat('yyyy/MM/dd').format(goal.dueDate);

          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 22, 92, 24).withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 45.0,
                  lineWidth: 8.0,
                  percent: percent > 1 ? 1 : percent,
                  center: Text(
                    "${(percent * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  progressColor: Colors.green[600]!,
                  backgroundColor: Colors.grey.shade300,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              goal.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Colors.green[600], size: 20),
                            onPressed: () => _editGoal(index),
                            tooltip: 'Edit',
                          ),
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: Colors.redAccent, size: 20),
                            onPressed: () => _deleteGoal(index),
                            tooltip: 'Delete',
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                          "Saved: \$${goal.savedAmount} / \$${goal.targetAmount} USD"),
                      Text("Due Date: $formattedDate",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Future: Add new goal screen
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Goal',
        backgroundColor: Colors.green[700],
      ),
    );
  }
}

class FinancialGoal {
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime dueDate;

  FinancialGoal({
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.dueDate,
  });
}
