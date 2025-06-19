import 'package:flutter/material.dart';
import 'package:jounior/widgets/interactivePie.dart';
import 'package:jounior/widgets/summary_box.dart';
import 'package:jounior/widgets/line_chart_single.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double totalIncome = 0.0;
  double totalExpenses = 0.0;

  // These are for the PIE chart only
  Map<String, double> incomeCategories = {};
  Map<String, double> expenseCategories = {};

  String selectedTimeFrame = 'Daily';
  final List<String> timeFrames = ['Daily', 'Weekly', 'Yearly'];

  final Map<String, Color> categoryColors = {};

  /// Time series for line chart tooltips
  Map<String, Map<String, double>> incomeTimeSeries = {};
  Map<String, Map<String, double>> expenseTimeSeries = {};

  @override
  void initState() {
    super.initState();
    _loadMockData('Daily');
  }

  void _loadMockData(String timeFrame) {
    // Category breakdowns for pie
    Map<String, Map<String, double>> incomeMock = {
      'Daily': {'Salary': 300.0, 'Freelance': 200.0},
      'Weekly': {'Salary': 900.0, 'Freelance': 400.0, 'Other': 200.0},
      'Yearly': {'Salary': 12000.0, 'Freelance': 5000.0, 'Investments': 3000.0}
    };
    Map<String, Map<String, double>> expenseMock = {
      'Daily': {'Food': 100.0, 'Transport': 50.0},
      'Weekly': {'Food': 400.0, 'Transport': 200.0, 'Fun': 100.0},
      'Yearly': {
        'Food': 3000.0,
        'Transport': 1500.0,
        'Entertainment': 2000.0,
        'Rent': 6000.0
      }
    };

    // This is for PIE chart
    incomeCategories = incomeMock[timeFrame] ?? {};
    expenseCategories = expenseMock[timeFrame] ?? {};

    totalIncome = incomeCategories.values.fold(0.0, (sum, item) => sum + item);
    totalExpenses =
        expenseCategories.values.fold(0.0, (sum, item) => sum + item);

    _generateCategoryColors(incomeCategories, true);
    _generateCategoryColors(expenseCategories, false);

    // This is for the LINE chart and tooltip breakdowns
    incomeTimeSeries = getIncomeTimeSeries(timeFrame);
    expenseTimeSeries = getExpenseTimeSeries(timeFrame);

    setState(() {});
  }

  void _generateCategoryColors(Map<String, double> categories, bool isIncome) {
    final List<Color> palette = [
      const Color(0xFF4CAF50), // Green
      const Color(0xFF2196F3), // Blue
      const Color(0xFFFF9800), // Orange
      const Color(0xFFE91E63), // Pink
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFFFEB3B), // Yellow
      const Color(0xFF3F51B5), // Indigo
      const Color(0xFF795548), // Brown
      const Color(0xFF607D8B), // Blue Grey
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF8BC34A), // Light Green
      const Color(0xFFCDDC39), // Lime
      const Color(0xFF03A9F4), // Light Blue
      const Color(0xFF673AB7), // Deep Purple
      const Color(0xFFBDBDBD), // Grey
      const Color(0xFFA1887F), // Warm Grey
      const Color(0xFF00E676), // Neon Green
      const Color(0xFFFFC107), // Amber
      const Color(0xFFB39DDB), // Lavender
    ];

    categories.forEach((key, _) {
      final mapKey = (isIncome ? 'income_' : 'expense_') + key;
      if (!categoryColors.containsKey(mapKey)) {
        final index = key.hashCode.abs() % palette.length;
        categoryColors[mapKey] = palette[index];
      }
    });
  }

  // --------- TIME SERIES DATA FOR LINE CHART (with breakdowns) ---------
  Map<String, Map<String, double>> getIncomeTimeSeries(String timeframe) {
    if (timeframe == 'Weekly') {
      return {
        'Mon': {'Salary': 200.0, 'Freelance': 0.0, 'Other': 0.0},
        'Tue': {'Salary': 300.0, 'Freelance': 50.0, 'Other': 0.0},
        'Wed': {'Salary': 220.0, 'Freelance': 0.0, 'Other': 0.0},
        'Thu': {'Salary': 400.0, 'Freelance': 30.0, 'Other': 0.0},
        'Fri': {'Salary': 350.0, 'Freelance': 0.0, 'Other': 0.0},
        'Sat': {'Salary': 250.0, 'Freelance': 90.0, 'Other': 20.0},
        'Sun': {'Salary': 280.0, 'Freelance': 20.0, 'Other': 30.0},
      };
    }
    if (timeframe == 'Yearly') {
      return {
        'Jan': {'Salary': 1500.0, 'Freelance': 100.0, 'Investments': 50.0},
        'Feb': {'Salary': 1700.0, 'Freelance': 200.0, 'Investments': 60.0},
        'Mar': {'Salary': 1600.0, 'Freelance': 100.0, 'Investments': 70.0},
        'Apr': {'Salary': 1900.0, 'Freelance': 0.0, 'Investments': 60.0},
        'May': {'Salary': 1800.0, 'Freelance': 200.0, 'Investments': 90.0},
        'Jun': {'Salary': 1750.0, 'Freelance': 0.0, 'Investments': 0.0},
        'Jul': {'Salary': 2000.0, 'Freelance': 100.0, 'Investments': 100.0},
        'Aug': {'Salary': 1950.0, 'Freelance': 0.0, 'Investments': 120.0},
        'Sep': {'Salary': 1700.0, 'Freelance': 60.0, 'Investments': 80.0},
        'Oct': {'Salary': 1850.0, 'Freelance': 0.0, 'Investments': 40.0},
        'Nov': {'Salary': 1750.0, 'Freelance': 100.0, 'Investments': 90.0},
        'Dec': {'Salary': 2100.0, 'Freelance': 0.0, 'Investments': 200.0},
      };
    }
    // Daily
    return {
      'Morning': {'Salary': 80.0, 'Freelance': 0.0},
      'Afternoon': {'Salary': 150.0, 'Freelance': 70.0},
      'Evening': {'Salary': 70.0, 'Freelance': 130.0},
    };
  }

  Map<String, Map<String, double>> getExpenseTimeSeries(String timeframe) {
    if (timeframe == 'Weekly') {
      return {
        'Mon': {'Food': 40.0, 'Transport': 10.0, 'Fun': 0.0},
        'Tue': {'Food': 70.0, 'Transport': 20.0, 'Fun': 0.0},
        'Wed': {'Food': 50.0, 'Transport': 10.0, 'Fun': 10.0},
        'Thu': {'Food': 90.0, 'Transport': 20.0, 'Fun': 20.0},
        'Fri': {'Food': 70.0, 'Transport': 40.0, 'Fun': 10.0},
        'Sat': {'Food': 60.0, 'Transport': 80.0, 'Fun': 70.0},
        'Sun': {'Food': 20.0, 'Transport': 20.0, 'Fun': 20.0},
      };
    }
    if (timeframe == 'Yearly') {
      return {
        'Jan': {
          'Food': 200.0,
          'Transport': 100.0,
          'Entertainment': 50.0,
          'Rent': 500.0
        },
        'Feb': {
          'Food': 180.0,
          'Transport': 120.0,
          'Entertainment': 60.0,
          'Rent': 500.0
        },
        'Mar': {
          'Food': 190.0,
          'Transport': 90.0,
          'Entertainment': 70.0,
          'Rent': 500.0
        },
        'Apr': {
          'Food': 210.0,
          'Transport': 110.0,
          'Entertainment': 80.0,
          'Rent': 500.0
        },
        'May': {
          'Food': 220.0,
          'Transport': 130.0,
          'Entertainment': 70.0,
          'Rent': 500.0
        },
        'Jun': {
          'Food': 170.0,
          'Transport': 120.0,
          'Entertainment': 60.0,
          'Rent': 500.0
        },
        'Jul': {
          'Food': 200.0,
          'Transport': 150.0,
          'Entertainment': 100.0,
          'Rent': 500.0
        },
        'Aug': {
          'Food': 210.0,
          'Transport': 140.0,
          'Entertainment': 120.0,
          'Rent': 500.0
        },
        'Sep': {
          'Food': 180.0,
          'Transport': 130.0,
          'Entertainment': 80.0,
          'Rent': 500.0
        },
        'Oct': {
          'Food': 190.0,
          'Transport': 100.0,
          'Entertainment': 90.0,
          'Rent': 500.0
        },
        'Nov': {
          'Food': 170.0,
          'Transport': 120.0,
          'Entertainment': 60.0,
          'Rent': 500.0
        },
        'Dec': {
          'Food': 220.0,
          'Transport': 130.0,
          'Entertainment': 130.0,
          'Rent': 500.0
        },
      };
    }
    // Daily
    return {
      'Morning': {'Food': 20.0, 'Transport': 10.0},
      'Afternoon': {'Food': 50.0, 'Transport': 20.0},
      'Evening': {'Food': 30.0, 'Transport': 20.0},
    };
  }

  List<String> getIncomeXAxisLabels() => incomeTimeSeries.keys.toList();
  List<double> getIncomeLineData() => incomeTimeSeries.values
      .map((categoryMap) => categoryMap.values.fold(0.0, (a, b) => a + b))
      .toList();

  List<String> getExpenseXAxisLabels() => expenseTimeSeries.keys.toList();
  List<double> getExpenseLineData() => expenseTimeSeries.values
      .map((categoryMap) => categoryMap.values.fold(0.0, (a, b) => a + b))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Timeframe dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Timeframe: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedTimeFrame,
                  items: timeFrames
                      .map((frame) =>
                          DropdownMenuItem(value: frame, child: Text(frame)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedTimeFrame = value;
                        _loadMockData(value);
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Summary Boxes
            Row(
              children: [
                Expanded(
                  child: SummaryBox(
                    title: "Total Income",
                    amount: totalIncome,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SummaryBox(
                    title: "Total Expenses",
                    amount: totalExpenses,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ---- Income Section ----
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      "Income Trend",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.green[700]),
                    ),
                    const SizedBox(height: 20),
                    LineChartSingle(
                      values: getIncomeLineData(),
                      xLabels: getIncomeXAxisLabels(),
                      color: Colors.green,
                      label: "Income",
                      categoryData: incomeTimeSeries,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      "Income Breakdown",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    InteractivePieChart(
                      data: incomeCategories,
                      categoryColors: categoryColors,
                      type: 'income_',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ---- Expense Section ----
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      "Expense Trend",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.red[700]),
                    ),
                    const SizedBox(height: 20),
                    LineChartSingle(
                      values: getExpenseLineData(),
                      xLabels: getExpenseXAxisLabels(),
                      color: Colors.red,
                      label: "Expense",
                      categoryData: expenseTimeSeries,
                    ),
                    const SizedBox(height: 22),
                    Text(
                      "Expense Breakdown",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    InteractivePieChart(
                      data: expenseCategories,
                      categoryColors: categoryColors,
                      type: 'expense_',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
