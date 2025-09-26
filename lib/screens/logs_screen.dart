import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'create_log_screen.dart';
import '../widgets/nav_bar.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final List<Map<String, dynamic>> _logs = [];

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Today's Log",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
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
                    _logs.fold<int>(
                      0,
                      (sum, log) => sum + (log['calories'] as int),
                    ).toString(),
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
            today,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // If no logs, show empty message
          if (_logs.isEmpty)
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
            ..._logs.map((log) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _mealSection(
                    context,
                    title: log['meal'],
                    time: log['time'],
                    items: log['items'],
                    tags: log['tags'],
                    totalCalories: log['calories'],
                    cost: log['price'],
                  ),
                )),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final newLog = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateLogScreen()),
          );

          if (newLog != null) {
            setState(() {
              _logs.add(newLog);
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

  Widget _mealSection(
    BuildContext context, {
    required String title,
    required String time,
    required List<Map<String, Object>> items,
    required List<String> tags,
    required int totalCalories,
    required double cost,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$title\n$time",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(height: 12),

            // Food items
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item["name"].toString()),
                      Text("${item["cal"]} cal"),
                    ],
                  ),
                )),

            const SizedBox(height: 8),

            // Tags
            Wrap(
              spacing: 8,
              children: tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.deepOrange.shade50,
                        labelStyle: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 8),

            // Total calories + cost
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$totalCalories cal",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$$cost",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
