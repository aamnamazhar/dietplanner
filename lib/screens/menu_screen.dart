import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  final String restaurant;
  const MenuScreen({required this.restaurant, super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  final List<String> filters = ["All Items", "Vegetarian", "Vegan", "Gluten-Free"];
  int selectedFilterIndex = 0;

  final List<Map<String, dynamic>> menuItems = [
    {
      "name": "Sausage McGriddles® Meal",
      "desc": "Sausage McGriddles®, Premium Roast Coffee (Small), Hash Browns",
      "kcal": 575,
      "price": 8.99,
      "img": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.mcdonalds.com%2Fus%2Fen-us%2Fmeal%2Fsausage-mcgriddles-meal.html&psig=AOvVaw3hqMYOPUwDBdgP_2Uh1U04&ust=1758998598304000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCKCBsseK948DFQAAAAAdAAAAABAE"
    },
    {
      "name": "Spicy McCrispy™",
      "desc": "Spicy crispy chicken sandwich you were dreaming about.",
      "kcal": 530,
      "price": 3.49,
      "img": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.mcdonalds.com%2Fus%2Fen-us%2Fproduct%2Fspicy-mccrispy-chicken-sandwich.html&psig=AOvVaw08a3gqfXu0m6NqIhpEvMmG&ust=1758998626213000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCPj29tOK948DFQAAAAAdAAAAABAH"
    },
    {
      "name": "Big Mac",
      "desc": "Two all-beef patties — it’s time to stop thinking.",
      "kcal": 580,
      "price": 8.99,
      "img": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.mcdonalds.com%2Fgb%2Fen-gb%2Fproduct%2Fbig-mac.html&psig=AOvVaw1zvG-zONBLgIHlZCuzWzmI&ust=1758998649797000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCMikyd-K948DFQAAAAAdAAAAABAE"
    },
    {
      "name": "Sausage Burrito",
      "desc": "Breakfast Burrito with fluffy scrambled egg, pork sausage...",
      "kcal": 310,
      "price": 12.99,
      "img": "https://www.google.com/url?sa=i&url=https%3A%2F%2Femilybites.com%2F2021%2F06%2Fturkey-sausage-breakfast-burritos.html&psig=AOvVaw3tXyeDDXlrS_Mxfbk6S7ki&ust=1758998684542000&source=images&cd=vfe&opi=89978449&ved=0CBUQjRxqFwoTCJi_ufGK948DFQAAAAAdAAAAABAE"
    },
  ];

  // Cart
  List<Map<String, dynamic>> cart = [];

  @override
  Widget build(BuildContext context) {
    double total = cart.fold(0, (sum, item) => sum + item["price"]);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.restaurant} Menu"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search menu items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                bool isSelected = index == selectedFilterIndex;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(filters[index]),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilterIndex = index;
                      });
                    },
                    selectedColor: Colors.orange,
                    backgroundColor: Colors.grey[200]!,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Menu list
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(item["img"], width: 60, height: 60, fit: BoxFit.cover),
                    ),
                    title: Text(item["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["desc"], maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text("${item["kcal"]} kcal", style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("\$${item["price"]}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.orange),
                          onPressed: () {
                            setState(() {
                              cart.add(item);
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Cart Bar
      bottomNavigationBar: cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Row(
                children: [
                  Text("${cart.length} items in cart"),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: Text("View Cart - \$${total.toStringAsFixed(2)}"),
                  )
                ],
              ),
            ),
    );
  }
}
