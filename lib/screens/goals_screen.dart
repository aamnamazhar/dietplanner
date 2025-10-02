import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../widgets/nav_bar.dart';
import '../services/budget_service.dart';
import 'set_budget_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  double dailyBudget = 0;
  double weeklyBudget = 0;
  double monthlyBudget = 0;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final budgets = await BudgetService().getBudgets();
    setState(() {
      dailyBudget = budgets['daily'] ?? 0;
      weeklyBudget = budgets['weekly'] ?? 0;
      monthlyBudget = budgets['monthly'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Actual spend calculations
    final todayMeals = MealRepository().meals.where(
      (m) =>
          m.date.year == now.year &&
          m.date.month == now.month &&
          m.date.day == now.day,
    );
    final thisWeekMeals = MealRepository().meals.where((m) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      return m.date.isAfter(weekStart) &&
          m.date.isBefore(now.add(const Duration(days: 1)));
    });
    final thisMonthMeals = MealRepository().meals.where(
      (m) => m.date.year == now.year && m.date.month == now.month,
    );

    final todaySpend = todayMeals.fold(0.0, (sum, m) => sum + m.price);
    final weekSpend = thisWeekMeals.fold(0.0, (sum, m) => sum + m.price);
    final monthSpend = thisMonthMeals.fold(0.0, (sum, m) => sum + m.price);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Goals",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () async {
              // await BudgetService().clearBudgets();
              setState(() {
                dailyBudget = weeklyBudget = monthlyBudget = 0;
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Estimated Spend"),
          const SizedBox(height: 12),
          _budgetTile("Daily", dailyBudget, Colors.blue),
          _budgetTile("Weekly", weeklyBudget, Colors.green),
          _budgetTile("Monthly", monthlyBudget, Colors.purple),
          const SizedBox(height: 24),

          _sectionTitle("Actual Spend"),
          const SizedBox(height: 12),
          _actualTile("Today", todaySpend, dailyBudget, Colors.orange),
          _actualTile("This Week", weekSpend, weeklyBudget, Colors.blue),
          _actualTile("This Month", monthSpend, monthlyBudget, Colors.green),
          const SizedBox(height: 28),

          // Set Budget Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SetBudgetScreen()),
                );
                _loadBudgets();
              },
              child: const Text(
                "+ Set Budget",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/meal');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/progress');
              break;
            case 2:
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/logs');
              break;
          }
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _budgetTile(String label, double budget, Color color) {
    return Card(
      elevation: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: color, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
                Text(
                  "\$${budget.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: budget == 0 ? 0 : 0.5,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 6,
            ),
            const SizedBox(height: 4),
            Text(
              "\$0.00  vs  \$${budget.toStringAsFixed(2)} estimated",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actualTile(String label, double spend, double budget, Color color) {
    final overBudget = spend > budget && budget > 0;
    final percent = budget > 0 ? (spend / budget).clamp(0.0, 1.0) : 0.0;

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${spend.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: overBudget ? Colors.red : color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade200,
              color: overBudget ? Colors.red : color,
              minHeight: 6,
            ),
            const SizedBox(height: 4),
            Text(
              overBudget
                  ? "${((spend - budget) / budget * 100).toStringAsFixed(0)}% over budget"
                  : budget > 0
                  ? "${((budget - spend) / budget * 100).toStringAsFixed(0)}% under budget"
                  : "No budget set",
              style: TextStyle(
                fontSize: 12,
                color: overBudget ? Colors.red : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
