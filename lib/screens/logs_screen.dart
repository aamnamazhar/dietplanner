import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meal_model.dart';
import '../widgets/nav_bar.dart';
import 'create_log_screen.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayMeals = MealRepository().meals
        .where(
          (m) =>
              m.date.year == today.year &&
              m.date.month == today.month &&
              m.date.day == today.day,
        )
        .toList();

    final groupedMeals = _groupMealsByTime(todayMeals);
    final totalCalories = todayMeals.fold<int>(
      0,
      (sum, meal) => sum + meal.calories,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Today's Log",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Total Calories",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    totalCalories.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            DateFormat('MMMM dd, yyyy').format(today),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          if (groupedMeals.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  "No logs yet. Tap + to add one!",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            )
          else
            ...groupedMeals.entries.map((entry) {
              final section = entry.key;
              final meals = entry.value;
              final totalCalories = meals.fold<int>(
                0,
                (sum, meal) => sum + meal.calories,
              );
              final totalCost = meals.fold<double>(
                0,
                (sum, meal) => sum + meal.price,
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              section,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "$totalCalories cal • \$${totalCost.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Meal items
                        ...meals.map(
                          (meal) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(meal.name),
                                Text("${meal.calories} cal"),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Tags row
                        Wrap(
                          spacing: 6,
                          children: [
                            _buildTag("#Healthy", Colors.green),
                            _buildTag("#QuickLunch", Colors.orange),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        onPressed: () async {
          final newLog = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateLogScreen()),
          );
          if (newLog != null && newLog is Meal) {
            setState(() {
              MealRepository().addMeal(newLog);
            });
          }
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
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
              break;
          }
        },
      ),
    );
  }

  Map<String, List<Meal>> _groupMealsByTime(List<Meal> meals) {
    final Map<String, List<Meal>> groups = {
      "Breakfast": [],
      "Lunch": [],
      "Dinner": [],
      "Snack": [],
    };

    for (var meal in meals) {
      final hour = meal.date.hour;
      if (hour >= 5 && hour < 11) {
        groups["Breakfast"]!.add(meal);
      } else if (hour >= 11 && hour < 16) {
        groups["Lunch"]!.add(meal);
      } else if (hour >= 16 && hour < 22) {
        groups["Dinner"]!.add(meal);
      } else {
        groups["Snack"]!.add(meal);
      }
    }

    groups.removeWhere((_, list) => list.isEmpty);
    return groups;
  }

  Widget _buildTag(String text, Color color) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide.none,
    );
  }
}
