import 'package:flutter/material.dart';
import 'package:jounior/controllers/dashboard_controller.dart';
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
    _loadData('Daily'); // Default time frame
  }

  Future<void> _loadData(String timeFrame) async {
    final dashboardData = await DashboardController.fetchDashboard();

    if (dashboardData != null) {
      setState(() {
        totalIncome = dashboardData['total_incomes']?.toDouble() ?? 0.0;
        totalExpenses = dashboardData['total_expenses']?.toDouble() ?? 0.0;

        // Safely convert the nested maps to Map<String, double>
        incomeCategories =
            _parseCategories(dashboardData['incomes_by_category']);
        expenseCategories =
            _parseCategories(dashboardData['expenses_by_category']);

        incomeTimeSeries = _parseTrendData(dashboardData['income_trend']);
        expenseTimeSeries = _parseTrendData(dashboardData['expense_trend']);

        _generateCategoryColors(incomeCategories, true);
        _generateCategoryColors(expenseCategories, false);
      });
    }
  }

// Helper function to parse categories (Map<String, dynamic> to Map<String, double>)
  Map<String, double> _parseCategories(Map<String, dynamic> categories) {
    return categories.map((key, value) => MapEntry(key, value.toDouble()));
  }

// Helper function to parse trend data (Map<String, dynamic> to Map<String, Map<String, double>>)
  Map<String, Map<String, double>> _parseTrendData(
      Map<String, dynamic> trendData) {
    return trendData.map((date, categories) {
      return MapEntry(
        date,
        (categories as Map<String, dynamic>)
            .map((category, total) => MapEntry(category, total.toDouble())),
      );
    });
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
  List<String> getIncomeXAxisLabels() => incomeTimeSeries.keys.toList();
  List<double> getIncomeLineData() => incomeTimeSeries.values
      .map((categoryMap) => categoryMap.values.fold(0.0, (a, b) => a + b))
      .toList();

  List<String> getExpenseXAxisLabels() => expenseTimeSeries.keys.toList();
  List<double> getExpenseLineData() => expenseTimeSeries.values
      .map((categoryMap) => categoryMap.values.fold(0.0, (a, b) => a + b))
      .toList();
  // Refresh function when user pulls down
  Future<void> _onRefresh() async {
    await _loadData(
        selectedTimeFrame); // Reload data for the selected timeframe
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Overview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _onRefresh,
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
                        });
                        _loadData(value); // Load data for selected timeframe
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
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SummaryBox(
                      title: "Total Expenses",
                      amount: totalExpenses,
                      color: Colors.red,
                      height: 40,
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
      ),
    );
  }
}
