import 'package:dietplanner/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Meal {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final DateTime date;

  Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.date,
  });
}


class MealRepository {
  static final MealRepository _instance = MealRepository._internal();
  factory MealRepository() => _instance;
  MealRepository._internal();

  final List<Meal> _meals = [];

  void addMeal(Meal meal) {
    _meals.add(meal);
  }

  List<Meal> get meals => _meals;

  List<Meal> getThisWeekMeals() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _meals.where((meal) {
      return meal.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          meal.date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }
}

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  List<double> getWeeklyCalories() {
    final repo = MealRepository();
    final meals = repo.getThisWeekMeals();
    List<double> weekly = List.filled(7, 0);

    for (var meal in meals) {
      int dayIndex = meal.date.weekday - 1;
      weekly[dayIndex] += meal.calories.toDouble();
    }
    return weekly;
  }

  Map<String, double> getDailyAverages() {
    final repo = MealRepository();
    final meals = repo.getThisWeekMeals();

    if (meals.isEmpty) {
      return {"calories": 0, "protein": 0, "carbs": 0, "fats": 0};
    }

    int days = meals.map((m) => m.date.weekday).toSet().length;

    return {
      "calories": meals.fold(0, (sum, m) => sum + m.calories) / days,
      "protein": meals.fold(0, (sum, m) => sum + m.protein) / days,
      "carbs": meals.fold(0, (sum, m) => sum + m.carbs) / days,
      "fats": meals.fold(0, (sum, m) => sum + m.fats) / days,
    };
  }

  @override
  Widget build(BuildContext context) {
    final weeklyCalories = getWeeklyCalories();
    final dailyAverages = getDailyAverages();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Progress",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Date Range ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.chevron_left, color: Colors.black54),
                SizedBox(width: 8),
                Text("Dec 25 - 31, 2025",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 20),

            // --- Tabs ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _ProgressTab(text: "Calories", selected: true),
                _ProgressTab(text: "Macros", selected: false),
                _ProgressTab(text: "Speed", selected: false),
              ],
            ),
            const SizedBox(height: 20),

            // --- Weekly Trend Chart ---
            const Text("Weekly Trend",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Text(days[value.toInt()],
                                style: const TextStyle(fontSize: 12));
                          }
                          return const Text("");
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 500),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true, horizontalInterval: 500),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        weeklyCalories.length,
                        (i) => FlSpot(i.toDouble(), weeklyCalories[i]),
                      ),
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Daily Averages ---
            const Text("Daily Averages",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _buildAverageCard(
              icon: Icons.local_fire_department,
              title: "Average Calories",
              value: "${dailyAverages['calories']!.toStringAsFixed(0)} kcal",
              goalText: "Goal: 2,500 kcal",
              progress: dailyAverages['calories']! / 2500,
              progressColor: Colors.orange,
            ),
            _buildAverageCard(
              icon: Icons.fitness_center,
              title: "Average Protein",
              value: "${dailyAverages['protein']!.toStringAsFixed(0)} g",
              goalText: "Goal: 150 g",
              progress: dailyAverages['protein']! / 150,
              progressColor: Colors.blue,
            ),
            _buildAverageCard(
              icon: Icons.rice_bowl,
              title: "Average Carbs",
              value: "${dailyAverages['carbs']!.toStringAsFixed(0)} g",
              goalText: "Goal: 300 g",
              progress: dailyAverages['carbs']! / 300,
              progressColor: Colors.green,
            ),
            _buildAverageCard(
              icon: Icons.local_pizza,
              title: "Average Fat",
              value: "${dailyAverages['fats']!.toStringAsFixed(0)} g",
              goalText: "Goal: 70 g",
              progress: dailyAverages['fats']! / 70,
              progressColor: Colors.red,
            ),
          ],
        ),
      ),

      // --- Bottom Navigation ---
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/meal');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/progress');
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

  // --- Average Card Widget ---
  Widget _buildAverageCard({
    required IconData icon,
    required String title,
    required String value,
    required String goalText,
    required double progress,
    required Color progressColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: progressColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0, 1),
              backgroundColor: Colors.grey.shade200,
              color: progressColor,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 6),
            Text(goalText, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// --- Tab Widget ---
class _ProgressTab extends StatelessWidget {
  final String text;
  final bool selected;
  const _ProgressTab({required this.text, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected ? Colors.deepOrange : Colors.grey)),
        if (selected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 3,
            width: 40,
            color: Colors.deepOrange,
          ),
      ],
    );
  }
}
