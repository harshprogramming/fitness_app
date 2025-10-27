<<<<<<< HEAD

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
=======
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/workout.dart';
import '../models/meal_entry.dart';
import '../models/badge.dart';      // your Badge model (not Flutter's)
import '../models/routine.dart';

class Repository {
  Database? _db;

  // Simple deterministic ID generator (fine for local apps / demos)
  int _seed = 1;
  String _id() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return _seed.toString();
  }

  // ------------------- Init & Schema -------------------
  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness.db');

    _db = await openDatabase(
      path,
      version: 4, // v1: workouts/meals, v2: badges, v3: routines, v4: settings
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE workouts(
            id TEXT PRIMARY KEY,
            type TEXT,
            dateTime TEXT,
            durationMin INTEGER,
            distanceKm REAL,
            strengthNotes TEXT,
            notes TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE meals(
            id TEXT PRIMARY KEY,
            date TEXT,
            mealType TEXT,
            name TEXT,
            calories INTEGER,
            serving TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE badges(
            code TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            earnedAt TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE routines(
            id TEXT PRIMARY KEY,
            title TEXT,
            category TEXT,
            level TEXT,
            durationMin INTEGER,
            focus TEXT,
            stepsJson TEXT,
            notes TEXT,
            isCustom INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE settings(
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
      onUpgrade: (db, oldV, newV) async {
        if (oldV < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS badges(
              code TEXT PRIMARY KEY,
              title TEXT,
              description TEXT,
              earnedAt TEXT
            )
          ''');
        }
        if (oldV < 3) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS routines(
              id TEXT PRIMARY KEY,
              title TEXT,
              category TEXT,
              level TEXT,
              durationMin INTEGER,
              focus TEXT,
              stepsJson TEXT,
              notes TEXT,
              isCustom INTEGER
            )
          ''');
        }
        if (oldV < 4) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS settings(
              key TEXT PRIMARY KEY,
              value TEXT
            )
          ''');
        }
      },
    );

    await _seedDemoIfEmpty();
  }

  Future<void> _seedDemoIfEmpty() async {
    final count = Sqflite.firstIntValue(
      await _db!.rawQuery('SELECT COUNT(*) FROM workouts'),
    );

    if ((count ?? 0) == 0) {
      // Seed a couple of workouts (skip badge awards during seed)
      await insertWorkout(
        Workout(
          id: _id(),
          type: 'Running',
          dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          durationMin: 30,
          distanceKm: 5.0,
          notes: 'Easy pace',
        ),
        awardBadges: false,
      );

      await insertWorkout(
        Workout(
          id: _id(),
          type: 'Weightlifting',
          dateTime: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
          durationMin: 45,
          strengthNotes: 'Bench 3x8 @ 60kg; Squat 3x5 @ 80kg',
        ),
        awardBadges: false,
      );

      // Seed a couple of meals
      await addMeal(
        MealEntry(
          id: _id(),
          date: DateTime.now(),
          mealType: MealType.breakfast,
          name: 'Oatmeal',
          calories: 250,
        ),
        awardBadges: false,
      );

      await addMeal(
        MealEntry(
          id: _id(),
          date: DateTime.now(),
          mealType: MealType.lunch,
          name: 'Chicken bowl',
          calories: 600,
        ),
        awardBadges: false,
      );
    }
  }

  // ------------------- Workouts -------------------
  Future<List<Workout>> fetchWorkouts() async {
    final rows = await _db!.query('workouts', orderBy: 'dateTime DESC');
    return rows.map((e) => Workout.fromJson(e)).toList();
  }

  Future<void> insertWorkout(Workout w, {bool awardBadges = true}) async {
    final toInsert = w.id.isEmpty ? w.copyWith(id: _id()) : w;
    await _db!.insert(
      'workouts',
      toInsert.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (awardBadges) await _maybeAwardBadges(afterWorkout: true);
  }

  Future<void> updateWorkout(Workout w, {bool awardBadges = false}) async {
    await _db!.update(
      'workouts',
      w.toJson(),
      where: 'id = ?',
      whereArgs: [w.id],
    );
    if (awardBadges) await _maybeAwardBadges(afterWorkout: true);
  }

  Future<void> deleteWorkout(String id) async {
    await _db!.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  // ------------------- Meals -------------------
  Future<List<MealEntry>> fetchMealsForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final rows = await _db!.query(
      'meals',
      where: 'date >= ? AND date < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date ASC',
    );

    return rows.map((e) => MealEntry.fromJson(e)).toList();
  }

  Future<void> addMeal(MealEntry m, {bool awardBadges = true}) async {
    final toInsert = m.id.isEmpty ? m.copyWith(id: _id()) : m;
    await _db!.insert(
      'meals',
      toInsert.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (awardBadges) await _maybeAwardBadges(afterMeal: true);
  }

  Future<void> deleteMeal(String id) async {
    await _db!.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> caloriesForDate(DateTime date) async {
    final list = await fetchMealsForDate(date);
    return list.fold<int>(0, (sum, e) => sum + e.calories);
  }

  Future<List<int>> caloriesForLastNDays(int n) async {
    final now = DateTime.now();
    final out = <int>[];
    for (var i = n - 1; i >= 0; i--) {
      out.add(await caloriesForDate(now.subtract(Duration(days: i))));
    }
    return out;
  }

  Future<List<double>> workoutsPerLastNDays(int n) async {
    final list = await fetchWorkouts();
    final now = DateTime.now();
    final buckets = List<double>.filled(n, 0);

    for (final w in list) {
      final day = DateTime(w.dateTime.year, w.dateTime.month, w.dateTime.day);
      final diff = now.difference(day).inDays;
      if (diff >= 0 && diff < n) {
        buckets[n - 1 - diff] += 1;
      }
    }
    return buckets;
  }

  // ------------------- Badges -------------------
  static final List<Badge> _catalog = [
    Badge(code: 'first_workout', title: 'First Workout', description: 'Logged your very first workout!'),
    Badge(code: 'five_workouts', title: 'Getting Consistent', description: 'Logged 5 total workouts.'),
    Badge(code: 'kcal_1000', title: 'Fuel Tracker', description: 'Logged 1000 calories total.'),
    Badge(code: 'streak_3', title: 'On a Roll', description: '3-day workout streak.'),
    Badge(code: 'streak_5', title: 'Locked-In', description: '5-day workout streak.'),
  ];

  Future<List<Badge>> fetchBadges() async {
    final rows = await _db!.query('badges');
    final earned = {for (final r in rows) r['code'] as String: r};
    return _catalog.map((b) {
      final row = earned[b.code];
      return row == null
          ? b
          : b.copyWith(earnedAt: DateTime.parse(row['earnedAt'] as String));
    }).toList();
  }

  Future<bool> _award(String code) async {
    final meta = _catalog.firstWhere((b) => b.code == code);
    final res = await _db!.insert(
      'badges',
      {
        'code': meta.code,
        'title': meta.title,
        'description': meta.description,
        'earnedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return res > 0;
  }

  Future<int> _totalWorkouts() async {
    final c = Sqflite.firstIntValue(
      await _db!.rawQuery('SELECT COUNT(*) FROM workouts'),
    );
    return (c ?? 0);
  }

  Future<int> _totalCaloriesLogged() async {
    final r = await _db!.rawQuery('SELECT SUM(calories) as s FROM meals');
    final v = (r.first['s'] as num?);
    return (v ?? 0).toInt();
  }

  Future<int> currentWorkoutStreakDays() async {
    final rows = await _db!.query('workouts', orderBy: 'dateTime DESC');
    if (rows.isEmpty) return 0;

    final dates = <DateTime>{};
    for (final r in rows) {
      final d = DateTime.parse(r['dateTime'] as String);
      dates.add(DateTime(d.year, d.month, d.day));
    }

    int streak = 0;
    DateTime cursor = DateTime.now();
    while (true) {
      final day = DateTime(cursor.year, cursor.month, cursor.day);
      if (dates.contains(day)) {
        streak += 1;
        cursor = cursor.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  Future<void> _maybeAwardBadges({bool afterWorkout = false, bool afterMeal = false}) async {
    final totalW = await _totalWorkouts();
    final totalKcal = await _totalCaloriesLogged();
    final streak = await currentWorkoutStreakDays();

    if (afterWorkout) {
      if (totalW >= 1) await _award('first_workout');
      if (totalW >= 5) await _award('five_workouts');
      if (streak >= 3) await _award('streak_3');
      if (streak >= 5) await _award('streak_5');
    }
    if (afterMeal) {
      if (totalKcal >= 1000) await _award('kcal_1000');
    }
  }

  // ------------------- Weekly Badge Reset -------------------
  Future<String?> _getSetting(String key) async {
    final rows = await _db!.query('settings', where: 'key = ?', whereArgs: [key]);
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> _setSetting(String key, String value) async {
    await _db!.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  DateTime _startOfWeek(DateTime d) {
    // Monday as start of week
    final day = DateTime(d.year, d.month, d.day);
    final delta = day.weekday - DateTime.monday; // 0 if Monday
    return day.subtract(Duration(days: delta));
  }

  /// Clears earned badges if we've crossed into a new week (Monday-based).
  Future<void> resetBadgesIfNewWeek() async {
    final now = DateTime.now();
    final thisMonday = _startOfWeek(now);

    final lastResetIso = await _getSetting('badges_last_reset_monday');
    final lastResetMonday =
    lastResetIso == null ? null : DateTime.tryParse(lastResetIso);

    final needReset = lastResetMonday == null || lastResetMonday.isBefore(thisMonday);

    if (needReset) {
      await _db!.delete('badges'); // wipe earned badges
      await _setSetting('badges_last_reset_monday', thisMonday.toIso8601String());
    }
  }

  // ------------------- Custom Routines -------------------
  Future<List<Routine>> fetchCustomRoutines() async {
    final rows = await _db!.query('routines', orderBy: 'title ASC');
    return rows.map((r) {
      final steps = List<String>.from(jsonDecode(r['stepsJson'] as String) as List);
      return Routine(
        id: r['id'] as String,
        title: r['title'] as String,
        category: RoutineCategory.values.firstWhere((e) => e.name == r['category']),
        level: RoutineLevel.values.firstWhere((e) => e.name == r['level']),
        durationMin: (r['durationMin'] as num).toInt(),
        focus: r['focus'] as String,
        steps: steps,
        notes: r['notes'] as String?,
        isCustom: ((r['isCustom'] ?? 0) as num).toInt() == 1,
      );
    }).toList();
  }

  Future<void> insertCustomRoutine(Routine r) async {
    final id = r.id.isEmpty ? _id() : r.id;
    await _db!.insert(
      'routines',
      {
        'id': id,
        'title': r.title,
        'category': r.category.name,
        'level': r.level.name,
        'durationMin': r.durationMin,
        'focus': r.focus,
        'stepsJson': jsonEncode(r.steps),
        'notes': r.notes,
        'isCustom': 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteCustomRoutine(String id) async {
    await _db!.delete('routines', where: 'id = ?', whereArgs: [id]);
>>>>>>> fe0a9a2 (Milestone 2)
  }
}
