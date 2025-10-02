import 'package:dietplanner/screens/food_codes_screen.dart';
import 'package:dietplanner/screens/menu_screen.dart';
import 'package:flutter/material.dart';

class RestaurantSelectionScreen extends StatefulWidget {
  @override
  _RestaurantSelectionScreenState createState() =>
      _RestaurantSelectionScreenState();
}

class _RestaurantSelectionScreenState extends State<RestaurantSelectionScreen> {
  final List<Map<String, dynamic>> restaurants = [
    {
      "name": "McDonald's",
      "desc": "Fast Food · Burgers",
      "color": Colors.red,
      "abbr": "M",
    },
    {
      "name": "KFC",
      "desc": "Fast Food · Chicken",
      "color": Colors.deepOrange,
      "abbr": "KFC",
    },
    {
      "name": "Subway",
      "desc": "Fast Food · Sandwiches",
      "color": Colors.green,
      "abbr": "SUB",
    },
    {
      "name": "Pizza Hut",
      "desc": "Fast Food · Pizzas",
      "color": Colors.redAccent,
      "abbr": "P",
    },
    {
      "name": "Taco Bell",
      "desc": "Fast Food · Mexican",
      "color": Colors.purple,
      "abbr": "TB",
    },
  ];

  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = restaurants
        .where((r) => r["name"].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Choose a Restaurant",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search restaurants...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.deepOrange,
                    width: 1.5,
                  ),
                ),
              ),
              onChanged: (val) => setState(() => query = val),
            ),
          ),

          //Grid of Restaurants
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final r = filtered[index];
                return GestureDetector(
                  onTap: () async {
                    final selected = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MenuScreen(restaurant: r["name"]),
                      ),
                    );
                    if (selected != null) Navigator.pop(context, selected);
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: r["color"],
                          radius: 28,
                          child: Text(
                            r["abbr"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          r["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r["desc"],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.card_giftcard, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FoodCodesScreen()),
          );
        },
      ),
    );
  }
}
