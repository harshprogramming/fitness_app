<<<<<<< HEAD

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
=======
import 'package:flutter/foundation.dart';

import '../models/workout.dart';
import '../models/meal_entry.dart';
import '../models/routine.dart';
import '../models/badge.dart';
import '../services/repository.dart';
import '../data/routines.dart' as presets;

class AppState extends ChangeNotifier {
  AppState(this.repo);
  final Repository repo;

  // -------- App State --------
  bool bootstrapped = false;
  bool loading = false;

  // -------- Daily Info --------
  int dailyCalorieGoal = 2100;
  DateTime selectedDate = DateTime.now();

  // -------- Data Collections --------
  List<Workout> workouts = [];
  List<MealEntry> mealsForSelectedDate = [];
  List<Badge> badges = [];
  List<Routine> routines = []; // presets + custom
  int caloriesToday = 0;
  int streakDays = 0;

  List<String> lastUnlockedBadges = [];

  // -------- Bootstrapping --------
  Future<void> bootstrap() async {
    loading = true;
    notifyListeners();

    workouts = await repo.fetchWorkouts();
    await _refreshMeals();

    // ✅ Weekly badge reset before fetching badges
    await repo.resetBadgesIfNewWeek();

    await _refreshBadgesAndStreak();
    await loadRoutines();

    loading = false;
    bootstrapped = true;
    notifyListeners();
  }

  // -------- Meals --------
  Future<void> _refreshMeals() async {
    mealsForSelectedDate = await repo.fetchMealsForDate(selectedDate);
    caloriesToday = await repo.caloriesForDate(selectedDate);
  }

  Future<void> addMeal(MealEntry m) async {
    await repo.addMeal(m);
    await _refreshMeals();
    await _refreshBadgesAndStreak();
    notifyListeners();
  }

  Future<void> removeMeal(String id) async {
    await repo.deleteMeal(id);
    await _refreshMeals();
    await _refreshBadgesAndStreak();
    notifyListeners();
  }

  Future<void> setSelectedDate(DateTime d) async {
    selectedDate = d;
    await _refreshMeals();
    notifyListeners();
  }

  // -------- Workouts --------
  Future<void> addWorkout(Workout w) async {
    await repo.insertWorkout(w);
    workouts = await repo.fetchWorkouts();
    await _refreshBadgesAndStreak();
    notifyListeners();
  }

  Future<void> updateWorkout(Workout w) async {
    await repo.updateWorkout(w);
    workouts = await repo.fetchWorkouts();
    await _refreshBadgesAndStreak();
    notifyListeners();
  }

  Future<void> removeWorkout(String id) async {
    await repo.deleteWorkout(id);
    workouts = await repo.fetchWorkouts();
    await _refreshBadgesAndStreak();
    notifyListeners();
  }

  // -------- Badges & Streak --------
  Future<void> _refreshBadgesAndStreak() async {
    badges = await repo.fetchBadges();
    streakDays = await repo.currentWorkoutStreakDays();
  }

  void consumeUnlockedBadges() {
    lastUnlockedBadges = [];
  }

  // -------- Routines (presets + custom) --------
  Future<void> loadRoutines() async {
    final custom = await repo.fetchCustomRoutines();
    routines = [...presets.routines, ...custom];
    notifyListeners();
  }

  Future<void> addCustomRoutine(Routine r) async {
    await repo.insertCustomRoutine(r);
    await loadRoutines();
  }

  Future<void> deleteCustomRoutine(String id) async {
    await repo.deleteCustomRoutine(id);
    await loadRoutines();
  }
>>>>>>> fe0a9a2 (Milestone 2)
}
