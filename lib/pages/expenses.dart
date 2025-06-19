import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jounior/controllers/AppController.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => __ExpensesmanegStateState();
}

class __ExpensesmanegStateState extends State<ExpensesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();

  List<String> categories = [];
  bool _recurrence = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _loadCategories();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      categories = prefs.getStringList('categories') ?? [];
      if (categories.isNotEmpty) {
        _selectedCategory = categories[0];
      }
    });
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', categories);
  }

  Future<void> _showCategoryDialog({String? categoryToEdit}) async {
    TextEditingController _categoryController = TextEditingController();
    if (categoryToEdit != null) {
      _categoryController.text = categoryToEdit;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: categoryToEdit == null
              ? Text('Add Category')
              : Text('Edit Category'),
          content: TextField(
            controller: _categoryController,
            decoration: InputDecoration(hintText: 'Enter Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_categoryController.text.isNotEmpty) {
                  setState(() {
                    if (categoryToEdit == null) {
                      categories.add(_categoryController.text);
                    } else {
                      categories[categories.indexOf(categoryToEdit)] =
                          _categoryController.text;
                    }
                    _saveCategories();
                    _selectedCategory = _categoryController.text;
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      double amount = double.parse(_amountController.text);
      String description = _descriptionController.text;
      String category = _selectedCategory;
      double date = _selectedDate.millisecondsSinceEpoch.toDouble();

      // إرسال مع _recurrence
      await expensesmanage(amount, date, category, description, _recurrence);
    }
  }

  Future<void> expensesmanage(double amount, double date, String category,
      String description, bool recurence) async {
    final prefs = await SharedPreferences.getInstance();
    String accessToken = await prefs.getString('access_token') ?? "";

    final url =
        Uri.parse('${AppController.baseUrl}/api/accounts/expenses/expenses');
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
          'recurence': recurence,
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
    final greenColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Expenses Management'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 37, 116, 78),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _showCategoryDialog,
                    child: Text('Add Category'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedCategory.isNotEmpty) {
                        _showCategoryDialog(categoryToEdit: _selectedCategory);
                      }
                    },
                    child: Text('Edit Category'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${DateFormat('EEE d MMM yyyy').format(_selectedDate)}',
                  ),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // checkbox
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 24,
                      height: 24,
                      color: _recurrence ? greenColor : Colors.grey.shade300,
                      child: Checkbox(
                        value: _recurrence,
                        onChanged: (bool? value) {
                          setState(() {
                            _recurrence = value ?? false;
                          });
                        },
                        activeColor: greenColor,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recursive Expense',
                    style: TextStyle(
                      fontSize: 16,
                      color: greenColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
