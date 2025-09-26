import 'package:dietplanner/screens/logs_screen.dart';
import 'package:dietplanner/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:dietplanner/screens/restaurant_screen.dart';
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
}


class BuildMealScreen extends StatefulWidget {
  const BuildMealScreen({super.key});

  @override
  State<BuildMealScreen> createState() => _BuildMealScreenState();
}

class _BuildMealScreenState extends State<BuildMealScreen> {

  List<Map<String, dynamic>> meals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Build Your Meal",
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.black)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.black)),
          const SizedBox(width: 8),
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

            if (meals.isEmpty)
              const Text("No items added yet.",
                  style: TextStyle(color: Colors.grey))
            else
              for (int i = 0; i < meals.length; i++)
                _mealItem(meals[i]["name"], meals[i]["details"], i),

            const SizedBox(height: 20),

            _sectionTitle("Nutrition Summary"),
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
  final newMeal = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => RestaurantSelectionScreen()),
  );
                  if (newMeal != null && newMeal is Map<String, dynamic>) {
                    setState(() {
                      meals.add({...newMeal, "quantity": 1});
                    });
                  }
                },
                child: const Text("+ Add More Items",
                    style: TextStyle(color: Colors.deepOrange)),
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
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  _logMeal(context);
                },
                child: const Text("Log Meal",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
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

  //Log Meals into Repository
  void _logMeal(BuildContext context) {
    for (var meal in meals) {
      if (meal["quantity"] > 0) {
        MealRepository().addMeal(Meal(
          name: meal["name"],
          calories: meal["calories"] * meal["quantity"],
          protein: meal["protein"] * meal["quantity"],
          carbs: meal["carbs"] * meal["quantity"],
          fats: meal["fats"] * meal["quantity"],
          date: DateTime.now(),
        ));
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Meal logged successfully!")),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LogsScreen()),
    );
  }


  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87));
  }

  Widget _mealItem(String name, String details, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200)),
      elevation: 3,
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
                  Text(name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(details, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            _counter(index),
          ],
        ),
      ),
    );
  }

  Widget _counter(int index) {
    return Row(
      children: [
        _roundButton(Icons.remove, Colors.grey.shade300, Colors.black, () {
          setState(() {
            if (meals[index]["quantity"] > 0) {
              meals[index]["quantity"]--;
            }
          });
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(meals[index]["quantity"].toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        _roundButton(Icons.add, Colors.deepOrange, Colors.white, () {
          setState(() {
            meals[index]["quantity"]++;
          });
        }),
      ],
    );
  }

  Widget _roundButton(
      IconData icon, Color bg, Color iconColor, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  Widget _nutritionSummary() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Estimated Price",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text("\$12.50",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Daily Goal"),
                Text("\$3.54", style: TextStyle(color: Colors.grey)),
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
        _progressCard("Cal", "495", Icons.local_fire_department, Colors.red),
      ],
    );
  }

  Widget _progressCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 16)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
