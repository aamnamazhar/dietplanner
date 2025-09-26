import 'package:flutter/material.dart';
import 'meal_builder_screen.dart';


class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  List<String> selectedGoals = [];

  String? selectedPreference;


  final List<Map<String, dynamic>> goals = [
    {
      "title": "Saving Money",
      "subtitle": "Find the best deals",
      "icon": Icons.savings,
      "color": Colors.green,
    },
    {
      "title": "Eating Healthy",
      "subtitle": "Nutritious choices",
      "icon": Icons.restaurant,
      "color": Colors.deepOrange,
    },
    {
      "title": "Finding Deals",
      "subtitle": "Best discounts",
      "icon": Icons.local_offer,
      "color": Colors.blue,
    },
  ];

  // Dietary Preferences
  final List<String> preferences = [
    "High Protein",
    "Low Carb",
    "Vegetarian",
    "Vegan",
    "Gluten Free",
    "Keto"
  ];

  void toggleGoal(String title) {
    setState(() {
      if (selectedGoals.contains(title)) {
        selectedGoals.remove(title);
      } else {
        if (selectedGoals.length < 3) {
          selectedGoals.add(title);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose up to 3 Goals",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Select what matters most to you",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Goals list
              Expanded(
                child: ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    final isSelected =
                        selectedGoals.contains(goal["title"] as String);

                    return GestureDetector(
                      onTap: () => toggleGoal(goal["title"]),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Colors.deepOrange
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: (goal["color"] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                goal["icon"] as IconData,
                                color: goal["color"] as Color,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal["title"] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    goal["subtitle"] as String,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? Colors.deepOrange
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Dietary Preferences",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: preferences.map((pref) {
                  final isSelected = selectedPreference == pref;
                  return ChoiceChip(
                    label: Text(pref),
                    selected: isSelected,
                    selectedColor: Colors.deepOrange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: Colors.grey.shade200,
                    onSelected: (_) {
                      setState(() {
                        selectedPreference = pref;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                 onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BuildMealScreen()
),
                  );
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
