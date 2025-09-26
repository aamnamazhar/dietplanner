import 'package:dietplanner/screens/menu_screen.dart';
import 'package:flutter/material.dart';

class RestaurantSelectionScreen extends StatefulWidget {
  @override
  _RestaurantSelectionScreenState createState() => _RestaurantSelectionScreenState();
}

class _RestaurantSelectionScreenState extends State<RestaurantSelectionScreen> {
  final List<Map<String, dynamic>> restaurants = [
    {"name": "McDonald's", "desc": "Fast Food · Burgers", "color": Colors.red, "abbr": "M"},
    {"name": "KFC", "desc": "Fast Food · Chicken", "color": Colors.deepOrange, "abbr": "KFC"},
    {"name": "Subway", "desc": "Fast Food · Sandwiches", "color": Colors.green, "abbr": "SUB"},
    {"name": "Pizza Hut", "desc": "Fast Food · Pizzas", "color": Colors.redAccent, "abbr": "P"},
    {"name": "Taco Bell", "desc": "Fast Food · Mexican", "color": Colors.purple, "abbr": "TB"},
  ];

  String query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = restaurants
        .where((r) => r["name"].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose a Restaurant"),
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
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search restaurants...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => query = val),
            ),
          ),

          // --- Grid of Restaurants ---
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
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
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(r["name"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(r["desc"],
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
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
        onPressed: () {
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.card_giftcard, color: Colors.white),
      ),
    );
  }
}


