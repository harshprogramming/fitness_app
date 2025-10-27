
enum MealType { breakfast, lunch, dinner, snacks }
class MealEntry {
  MealEntry({required this.id, required this.date, required this.mealType, required this.name, required this.calories, this.serving});
  final String id;
  final DateTime date;
  final MealType mealType;
  final String name;
  final int calories;
  final String? serving;
}
