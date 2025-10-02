import 'package:dietplanner/models/meal_model.dart';
import 'package:flutter/material.dart';

class MenuDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const MenuDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Menu Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildMenuImage(
                item["img"],
                width: double.infinity,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),

            // Title & Description
            Text(
              item["name"],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(item["desc"], style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),

            // Nutrition Info
            const Text(
              "Nutrition Information",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _nutritionBox("${item["kcal"]}", "Calories", Colors.orange),
                  _nutritionBox(
                    "${item["protein"]}g",
                    "Protein",
                    Colors.orange,
                  ),
                  _nutritionBox("${item["carbs"]}g", "Carbs", Colors.blue),
                  _nutritionBox("${item["fats"]}g", "Fat", Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Estimated Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Estimated Price",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${(item["price"] * quantity).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Serving Size
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Serving Size",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _roundButton(Icons.remove, () {
                      setState(() {
                        if (quantity > 1) quantity--;
                      });
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _roundButton(Icons.add, () {
                      setState(() {
                        quantity++;
                      });
                    }),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Add to Meal Button
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
                  MealRepository().addMeal(
                    Meal(
                      name: item["name"],
                      calories: item["kcal"] * quantity,
                      protein: (item["protein"] ?? 0) * quantity,
                      carbs: (item["carbs"] ?? 0) * quantity,
                      fats: (item["fats"] ?? 0) * quantity,
                      price: (item["price"] ?? 0) * quantity,
                      date: DateTime.now(),
                      tags: [],
                    ),
                  );

                  Navigator.pop(context, true);
                },
                child: const Text(
                  "+ Add to Meal",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Image Loader
  Widget _buildMenuImage(String path, {double? width, double? height}) {
    final isAsset = path.startsWith("assets/");
    return isAsset
        ? Image.asset(
            path,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 100),
          )
        : Image.network(
            path,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 100),
          );
  }

  /// Nutrition Box Widget
  Widget _nutritionBox(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  /// Quantity Buttons
  Widget _roundButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
      ),
      child: IconButton(onPressed: onTap, icon: Icon(icon, size: 18)),
    );
  }
}
