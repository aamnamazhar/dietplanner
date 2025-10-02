class Meal {
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final double price;
  final DateTime date;

  Meal({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.price,
    required this.date,
    required List<String> tags,
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

  void clearMeals() {
    _meals.clear();
  }

  void removeMeal(Meal meal) {
    _meals.remove(meal);
  }
}
