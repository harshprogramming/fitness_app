<<<<<<< HEAD

enum MealType { breakfast, lunch, dinner, snacks }
class MealEntry {
  MealEntry({required this.id, required this.date, required this.mealType, required this.name, required this.calories, this.serving});
=======
enum MealType { breakfast, lunch, dinner, snacks }

class MealEntry {
  MealEntry({
    required this.id,
    required this.date,
    required this.mealType,
    required this.name,
    required this.calories,
    this.serving,
  });

>>>>>>> fe0a9a2 (Milestone 2)
  final String id;
  final DateTime date;
  final MealType mealType;
  final String name;
  final int calories;
  final String? serving;
<<<<<<< HEAD
=======

  /// Allows convenient updates without rebuilding the whole object.
  MealEntry copyWith({
    String? id,
    DateTime? date,
    MealType? mealType,
    String? name,
    int? calories,
    String? serving,
  }) {
    return MealEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      serving: serving ?? this.serving,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date.toIso8601String(),
    'mealType': mealType.name,
    'name': name,
    'calories': calories,
    'serving': serving,
  };

  static MealEntry fromJson(Map<String, dynamic> json) => MealEntry(
    id: json['id'] as String,
    date: DateTime.parse(json['date'] as String),
    mealType: MealType.values.firstWhere((e) => e.name == json['mealType']),
    name: json['name'] as String,
    calories: (json['calories'] as num).toInt(),
    serving: json['serving'] as String?,
  );
>>>>>>> fe0a9a2 (Milestone 2)
}
