
import '../models/workout.dart';
import '../models/meal_entry.dart';

class Repository {
  final List<Workout> _workouts = [];
  final List<MealEntry> _meals = [];
  int _seed = 1;
  String _id(){ _seed = (_seed * 1103515245 + 12345) & 0x7fffffff; return _seed.toString(); }
  List<Workout> getWorkouts()=> List.unmodifiable(_workouts);
  void addWorkout(Workout w){ _workouts.add(w.copyWith(id: _id())); }
  void updateWorkout(Workout w){ final i=_workouts.indexWhere((e)=>e.id==w.id); if(i!=-1)_workouts[i]=w; }
  void removeWorkout(String id){ _workouts.removeWhere((w)=>w.id==id); }
  List<MealEntry> getMealsForDate(DateTime d){ final day=DateTime(d.year,d.month,d.day); return _meals.where((m){final md=DateTime(m.date.year,m.date.month,m.date.day); return md==day;}).toList(growable:false); }
  void addMeal(MealEntry m){ _meals.add(MealEntry(id:_id(),date:m.date,mealType:m.mealType,name:m.name,calories:m.calories,serving:m.serving)); }
  void removeMeal(String id){ _meals.removeWhere((m)=>m.id==id); }
  int caloriesForDate(DateTime d)=> getMealsForDate(d).fold(0,(s,m)=>s+m.calories);
  void seedDemo(){
    if(_workouts.isNotEmpty||_meals.isNotEmpty) return;
    addWorkout(Workout(id:'s1',type:'Running',dateTime:DateTime.now().subtract(Duration(days:1)),durationMin:30,distanceKm:5.0));
    addWorkout(Workout(id:'s2',type:'Weightlifting',dateTime:DateTime.now().subtract(Duration(days:2)),durationMin:45,strengthNotes:'Bench 3x8'));
    addMeal(MealEntry(id:'m1',date:DateTime.now(),mealType:MealType.breakfast,name:'Oatmeal',calories:250));
    addMeal(MealEntry(id:'m2',date:DateTime.now(),mealType:MealType.lunch,name:'Chicken bowl',calories:600));
  }
}
