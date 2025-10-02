import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class TrendingMealsScreen extends StatelessWidget {
  const TrendingMealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meals = MealRepository().meals;

    // Group and count meals by name for the current week
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekMeals = meals.where(
      (m) =>
          m.date.isAfter(weekStart) &&
          m.date.isBefore(weekStart.add(const Duration(days: 7))),
    );

    final Map<String, Map<String, dynamic>> mealCounts = {};
    for (var m in weekMeals) {
      if (!mealCounts.containsKey(m.name)) {
        mealCounts[m.name] = {"count": 0, "calories": m.calories};
      }
      mealCounts[m.name]!["count"] = mealCounts[m.name]!["count"] + 1;
    }

    final sortedMeals = mealCounts.entries.toList()
      ..sort((a, b) => b.value["count"].compareTo(a.value["count"]));

    final top5Deals = [
      {"title": "50% Off Any Pizza", "status": "Active"},
      {"title": "Buy 1 Get 1 Free Burger", "status": "Active"},
      {"title": "Free Dessert w/ Entrée", "status": "Active"},
      {"title": "Happy Hour 3-6pm", "status": "Limited"},
      {"title": "\$5 Lunch Special", "status": "Active"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "What's Trending",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Most Logged Meals This Week"),
          const SizedBox(height: 10),
          if (sortedMeals.isEmpty)
            const Text(
              "No trending meals yet.",
              style: TextStyle(color: Colors.grey),
            )
          else
            ...sortedMeals.map((entry) {
              final name = entry.key;
              final count = entry.value["count"];
              final calories = entry.value["calories"];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.fastfood, color: Colors.deepOrange),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text("$count logs"),
                trailing: Text(
                  "$calories cal",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),

          const SizedBox(height: 24),
          _sectionTitle("Top 5 Deals Logged"),
          const SizedBox(height: 10),
          ...top5Deals.map(
            (deal) => _dealTile(deal["title"]!, deal["status"]!),
          ),

          const SizedBox(height: 24),
          _sectionTitle("Average Calories for a Burger Combo"),
          const SizedBox(height: 12),
          _calorieCard(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _dealTile(String title, String status) {
    final color = status == "Active"
        ? Colors.green
        : status == "Limited"
        ? Colors.orange
        : Colors.grey;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            status,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _calorieCard() {
    final burgerComboCalories = 1247;
    final dailyRecommended = 2000;
    final percent = burgerComboCalories / dailyRecommended;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "$burgerComboCalories",
            style: const TextStyle(
              color: Colors.deepOrange,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Average Calories",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation(Colors.deepOrange),
          ),
          const SizedBox(height: 8),
          Text(
            "${(percent * 100).toStringAsFixed(0)}% of daily recommended intake",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
