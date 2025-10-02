import 'package:flutter/material.dart';
import '../services/budget_service.dart';

class SetBudgetScreen extends StatefulWidget {
  const SetBudgetScreen({super.key});

  @override
  State<SetBudgetScreen> createState() => _SetBudgetScreenState();
}

class _SetBudgetScreenState extends State<SetBudgetScreen> {
  final dailyController = TextEditingController();
  final weeklyController = TextEditingController();
  final monthlyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final budgets = await BudgetService().getBudgets();
    setState(() {
      dailyController.text = budgets['daily']?.toString() ?? '';
      weeklyController.text = budgets['weekly']?.toString() ?? '';
      monthlyController.text = budgets['monthly']?.toString() ?? '';
    });
  }

  Future<void> _saveBudgets() async {
    final daily = double.tryParse(dailyController.text) ?? 0;
    final weekly = double.tryParse(weeklyController.text) ?? 0;
    final monthly = double.tryParse(monthlyController.text) ?? 0;

    await BudgetService().setBudgets(
      daily: daily,
      weekly: weekly,
      monthly: monthly,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Set Budget",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _budgetField("Daily Budget", dailyController),
            const SizedBox(height: 16),
            _budgetField("Weekly Budget", weeklyController),
            const SizedBox(height: 16),
            _budgetField("Monthly Budget", monthlyController),
            const Spacer(),
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
                onPressed: _saveBudgets,
                child: const Text(
                  "Save Budget",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
