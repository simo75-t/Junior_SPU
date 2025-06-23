import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:jounior/controllers/savingGoals.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FinancialGoalsScreen extends StatefulWidget {
  @override
  _FinancialGoalsScreenState createState() => _FinancialGoalsScreenState();
}

class _FinancialGoalsScreenState extends State<FinancialGoalsScreen> {
  List<SavingGoal> goals = []; // Initialize an empty list

  @override
  void initState() {
    super.initState();
    _fetchGoals(); // Fetch goals when the screen loads
  }

  // Method to fetch financial goals from the API
  void _fetchGoals() async {
    try {
      final fetchedGoals = await SavingGoalController.fetchSavingGoals();
      setState(() {
        goals = fetchedGoals;
      });
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load goals')));
    }
  }

// Method to delete the goal with confirmation dialog
  void _deleteGoal(int index) {
    final goalId = goals[index].id; // Get the goal ID
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content:
            Text('Are you sure you want to delete "${goals[index].title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await SavingGoalController.deleteSavingGoal(
                    goalId); // Delete goal
                setState(() {
                  goals.removeAt(index); // Remove goal from the list
                });
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Failed to delete goal: $e'))); // Handle error
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Method to edit the goal's details
// Method to edit the goal's details
  void _editGoal(int index) {
    final goal = goals[index];
    final titleController = TextEditingController(text: goal.title);
    final targetAmountController =
        TextEditingController(text: goal.targetAmount.toString());
    final currentAmountController =
        TextEditingController(text: goal.currentAmount.toString());
    final dueDateController = TextEditingController(
        text: DateFormat('yyyy/MM/dd').format(goal.deadline!));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Goal Title'),
            ),
            TextField(
              controller: targetAmountController,
              decoration: const InputDecoration(labelText: 'Target Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: currentAmountController,
              decoration: const InputDecoration(labelText: 'Current Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dueDateController,
              decoration: const InputDecoration(labelText: 'Due Date'),
              readOnly: true,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: goal.deadline!,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    goal.deadline = pickedDate;
                    dueDateController.text =
                        DateFormat('yyyy/MM/dd').format(goal.deadline!);
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedGoal = SavingGoal(
                title: titleController.text,
                targetAmount:
                    double.tryParse(targetAmountController.text) ?? 0.0,
                currentAmount:
                    double.tryParse(currentAmountController.text) ?? 0.0,
                deadline:
                    DateFormat('yyyy/MM/dd').parse(dueDateController.text),
              );

              try {
                final updatedGoalResponse =
                    await SavingGoalController.updateSavingGoal(
                        goal.id, updatedGoal);
                setState(() {
                  goals[index] =
                      updatedGoalResponse; // Update the goal in the list
                });
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text('Failed to update goal: $e'))); // Handle error
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  // Method to add a new goal
  void _addNewGoal() {
    final titleController = TextEditingController();
    final targetAmountController = TextEditingController();
    final currentAmountController = TextEditingController();
    final dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add New Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Goal Title'),
            ),
            TextField(
              controller: targetAmountController,
              decoration: const InputDecoration(labelText: 'Target Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: currentAmountController,
              decoration: const InputDecoration(labelText: 'Saved Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dueDateController,
              decoration: const InputDecoration(labelText: 'Due Date'),
              readOnly: true,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    dueDateController.text =
                        DateFormat('yyyy/MM/dd').format(pickedDate);
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newGoal = SavingGoal(
                title: titleController.text,
                targetAmount:
                    double.tryParse(targetAmountController.text) ?? 0.0,
                currentAmount:
                    double.tryParse(currentAmountController.text) ?? 0.0,
                deadline:
                    DateFormat('yyyy/MM/dd').parse(dueDateController.text),
              );

              try {
                final createdGoal =
                    await SavingGoalController.createSavingGoal(newGoal);
                setState(() {
                  goals.add(createdGoal); // Add the new goal to the list
                });
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create goal')));
              }
            },
            child: const Text('Add Goal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Goals',
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
          final percent = goal.currentAmount / goal.targetAmount;
          final formattedDate = DateFormat('yyyy/MM/dd').format(goal.deadline!);

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
                          "Saved: \$${goal.currentAmount} / \$${goal.targetAmount} USD"),
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
        onPressed: _addNewGoal,
        child: Icon(Icons.add),
        tooltip: 'Add New Goal',
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
