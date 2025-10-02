import 'package:dietplanner/models/meal_model.dart';
import 'package:dietplanner/screens/logs_screen.dart';
import 'package:dietplanner/screens/restaurant_screen.dart';
import 'package:dietplanner/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'trending_screen.dart';
import 'feedback_screen.dart';

class BuildMealScreen extends StatefulWidget {
  const BuildMealScreen({super.key});

  @override
  State<BuildMealScreen> createState() => _BuildMealScreenState();
}

class _BuildMealScreenState extends State<BuildMealScreen> {
  List<Meal> get mealList => MealRepository().meals;

  double get totalPrice {
    double total = 0;
    for (var meal in mealList) {
      total += meal.price;
    }
    return total;
  }

  int get totalCalories {
    int total = 0;
    for (var meal in mealList) {
      total += meal.calories;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Build Your Meal",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FeedbackScreen()),
              );
            },
            icon: const Icon(Icons.star_border, color: Colors.black),
            tooltip: "Feedback",
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrendingMealsScreen()),
              );
            },
            icon: const Icon(Icons.trending_up, color: Colors.black),
            tooltip: "Trending",
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Your Meal"),
            const SizedBox(height: 10),

            if (mealList.isEmpty)
              const Text(
                "No items added yet.",
                style: TextStyle(color: Colors.grey),
              )
            else
              for (final meal in mealList)
                _mealItem(
                  meal.name,
                  "${meal.calories} kcal • \$${meal.price.toStringAsFixed(2)}",
                ),

            const SizedBox(height: 20),

            _sectionTitle("Nutrition & Price Summary"),
            const SizedBox(height: 10),
            _nutritionSummary(),
            const SizedBox(height: 20),

            _sectionTitle("Goal Progress"),
            const SizedBox(height: 10),
            _goalProgress(),
            const SizedBox(height: 20),

            Center(
              child: TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantSelectionScreen(),
                    ),
                  );
                  setState(() {});
                },
                child: const Text(
                  "+ Add More Items",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _logMeal(context);
                },
                child: const Text(
                  "Log Meal",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
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

  void _logMeal(BuildContext context) {
    if (mealList.isEmpty) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Meal logged successfully!")));

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogsScreen()),
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

  Widget _mealItem(String name, String details) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 4,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.fastfood, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(details, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionSummary() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "\$${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Calories"),
                Text(
                  "$totalCalories kcal",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _progressCard("Saving", "5%", Icons.savings, Colors.green),
        _progressCard("Item", "Free", Icons.local_dining, Colors.orange),
        _progressCard(
          "Cal",
          "$totalCalories",
          Icons.local_fire_department,
          Colors.red,
        ),
      ],
    );
  }

  Widget _progressCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        shadowColor: Colors.black12,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
