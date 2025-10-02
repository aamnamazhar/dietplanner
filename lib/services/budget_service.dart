import 'package:shared_preferences/shared_preferences.dart';

class BudgetService {
  static const _dailyKey = 'daily_budget';
  static const _weeklyKey = 'weekly_budget';
  static const _monthlyKey = 'monthly_budget';

  Future<void> setBudgets({
    required double daily,
    required double weekly,
    required double monthly,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_dailyKey, daily);
    await prefs.setDouble(_weeklyKey, weekly);
    await prefs.setDouble(_monthlyKey, monthly);
  }

  Future<Map<String, double>> getBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'daily': prefs.getDouble(_dailyKey) ?? 0.0,
      'weekly': prefs.getDouble(_weeklyKey) ?? 0.0,
      'monthly': prefs.getDouble(_monthlyKey) ?? 0.0,
    };
  }
}
