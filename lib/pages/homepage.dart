import 'package:flutter/material.dart';
import 'package:jounior/pages/IncomeExpensePage.dart';
import 'package:jounior/pages/dashboardpage.dart'; // Import the DashboardPage
import 'package:jounior/pages/finincial_goals.dart';
import 'package:jounior/pages/settingspage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/imges/woman.png',
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Settingspage()),
                  );
                },
                child: Container(
                  child: Text(
                    "Profile Settings",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 37, 116, 78),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IncomeExpensePage(),
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    "Manage income and expense",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 37, 116, 78),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FinancialGoalsScreen(),
                    ),
                  );
                },
                child: Container(
                  child: Text(
                    "Financial Goals",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 37, 116, 78),
                    ),
                  ),
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Instead of showing an image, we show the Dashboard
            Expanded(
              child: DashboardPage(), // Embed the DashboardPage here
            ),
          ],
        ),
      ),
    );
  }
}
