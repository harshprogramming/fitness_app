
import 'package:flutter/foundation.dart';
import '../models/workout.dart';
import '../models/meal_entry.dart';
import '../services/repository.dart';

class AppState extends ChangeNotifier {
  AppState(this.repo){ repo.seedDemo(); }
  final Repository repo;
  int dailyCalorieGoal = 2100;
  DateTime selectedDate = DateTime.now();
  List<Workout> get workouts => repo.getWorkouts();
  List<MealEntry> get mealsForSelectedDate => repo.getMealsForDate(selectedDate);
  int get caloriesToday => repo.caloriesForDate(selectedDate);
  void addWorkout(Workout w){ repo.addWorkout(w); notifyListeners(); }
  void updateWorkout(Workout w){ repo.updateWorkout(w); notifyListeners(); }
  void removeWorkout(String id){ repo.removeWorkout(id); notifyListeners(); }
  void addMeal(MealEntry m){ repo.addMeal(m); notifyListeners(); }
  void removeMeal(String id){ repo.removeMeal(id); notifyListeners(); }
  void setSelectedDate(DateTime d){ selectedDate=d; notifyListeners(); }
}
