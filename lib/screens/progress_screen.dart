import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/meal_model.dart';
import '../widgets/nav_bar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime selectedWeek = DateTime.now();
  int selectedTab = 0; // 0 = Calories, 1 = Macros, 2 = Spend

  final goals = {
    'calories': 2500.0,
    'protein': 160.0,
    'carbs': 300.0,
    'fats': 82.0,
  };

  @override
  Widget build(BuildContext context) {
    final weekStart = selectedWeek.subtract(
      Duration(days: selectedWeek.weekday - 1),
    );
    final weekEnd = weekStart.add(const Duration(days: 6));

    // Filter meals for this week
    final weeklyMeals = MealRepository().meals.where((meal) {
      final date = meal.date;
      return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          date.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();

    // Group meals by weekday
    final Map<int, List<Meal>> dailyGroups = {
      for (var i = 1; i <= 7; i++) i: [],
    };
    for (var meal in weeklyMeals) {
      dailyGroups[meal.date.weekday]?.add(meal);
    }

    // Aggregate values
    final dailyCalories = List<double>.generate(
      7,
      (i) =>
          dailyGroups[i + 1]!.fold(0, (sum, m) => sum + m.calories.toDouble()),
    );
    final dailyProtein = List<double>.generate(
      7,
      (i) =>
          dailyGroups[i + 1]!.fold(0, (sum, m) => sum + m.protein.toDouble()),
    );
    final dailyCarbs = List<double>.generate(
      7,
      (i) => dailyGroups[i + 1]!.fold(0, (sum, m) => sum + m.carbs.toDouble()),
    );
    final dailyFats = List<double>.generate(
      7,
      (i) => dailyGroups[i + 1]!.fold(0, (sum, m) => sum + m.fats.toDouble()),
    );
    final dailySpend = List<double>.generate(
      7,
      (i) => dailyGroups[i + 1]!.fold(0, (sum, m) => sum + m.price),
    );

    final avgCalories = _average(dailyCalories);
    final avgProtein = _average(dailyProtein);
    final avgCarbs = _average(dailyCarbs);
    final avgFats = _average(dailyFats);
    final avgSpend = _average(dailySpend);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Progress",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Week navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    selectedWeek = selectedWeek.subtract(
                      const Duration(days: 7),
                    );
                  }),
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  "Week of ${DateFormat('MMM dd, yyyy').format(weekStart)} - ${DateFormat('MMM dd, yyyy').format(weekEnd)}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    selectedWeek = selectedWeek.add(const Duration(days: 7));
                  }),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tabButton("Calories", 0),
                _tabButton("Macros", 1),
                _tabButton("Spend", 2),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Chart & Averages
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Weekly Trend",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedTab == 0
                        ? "Daily calorie intake this week"
                        : selectedTab == 1
                        ? "Daily macros this week"
                        : "Daily spend this week",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 260,
                    child: LineChart(
                      _buildChartData(
                        selectedTab == 0
                            ? dailyCalories
                            : selectedTab == 1
                            ? dailyProtein
                            : dailySpend,
                        color: selectedTab == 0
                            ? Colors.deepOrange
                            : selectedTab == 1
                            ? Colors.blue
                            : Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (selectedTab == 0) ...[
                    _averageTile(
                      "Average Calories",
                      avgCalories,
                      goals['calories']!,
                      Colors.deepOrange,
                      "+5% vs last week",
                    ),
                  ] else if (selectedTab == 1) ...[
                    _averageTile(
                      "Average Protein",
                      avgProtein,
                      goals['protein']!,
                      Colors.blue,
                      "+12% vs last week",
                      unit: "g",
                    ),
                    _averageTile(
                      "Average Carbs",
                      avgCarbs,
                      goals['carbs']!,
                      Colors.green,
                      "-3% vs last week",
                      unit: "g",
                    ),
                    _averageTile(
                      "Average Fats",
                      avgFats,
                      goals['fats']!,
                      Colors.amber,
                      "+8% vs last week",
                      unit: "g",
                    ),
                  ] else ...[
                    _averageTile(
                      "Average Spend",
                      avgSpend,
                      50,
                      Colors.green,
                      "+2% vs last week",
                      unit: "\$",
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/meal');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/goals');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/logs');
              break;
          }
        },
      ),
    );
  }

  Widget _tabButton(String text, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.deepOrange : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  LineChartData _buildChartData(List<double> data, {required Color color}) {
    final maxValue =
        (data.isEmpty ? 0 : data.reduce((a, b) => a > b ? a : b)) + 200;

    return LineChartData(
      minY: 0,
      maxY: maxValue.toDouble(),
      gridData: FlGridData(
        show: true,
        horizontalInterval: (maxValue / 4).ceilToDouble(),
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.shade300, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            getTitlesWidget: (value, meta) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              final labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
              if (value >= 1 && value <= 7) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    labels[value.toInt() - 1],
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: data
              .asMap()
              .entries
              .map((e) => FlSpot((e.key + 1).toDouble(), e.value))
              .toList(),
          isCurved: true,
          color: color,
          barWidth: 3,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }

  Widget _averageTile(
    String label,
    double value,
    double goal,
    Color color,
    String comparison, {
    String unit = "",
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.circle, color: color, size: 12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "For day this week",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: goal == 0 ? 0 : (value / goal).clamp(0.0, 1.0),
                    backgroundColor: Colors.grey.shade200,
                    color: color,
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${(value / goal * 100).toStringAsFixed(0)}% of daily goal ($goal${unit.isNotEmpty ? unit : ""})",
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${value.toStringAsFixed(0)}$unit",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
                Text(
                  comparison,
                  style: TextStyle(
                    fontSize: 11,
                    color: comparison.startsWith("-")
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _average(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }
}
