<<<<<<< HEAD

import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../widgets/stat_card.dart';
class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context){
    final app = AppScope.of(context);
    final workoutsThisWeek = app.workouts.where((w){ final now=DateTime.now(); final sow=DateTime(now.year,now.month,now.day).subtract(Duration(days:now.weekday-1)); return w.dateTime.isAfter(sow);}).length;
    final calories = app.caloriesToday;
    return Scaffold(appBar: AppBar(title: const Text('Fitness Tracker'), actions:[IconButton(icon: const Icon(Icons.settings_outlined), onPressed: ()=>Navigator.of(context).pushNamed('/settings'))]),
      body: ListView(padding: const EdgeInsets.all(16), children:[
        Text('Today', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height:12),
        Row(children:[Expanded(child:StatCard(title:'Workouts this week', value:'$workoutsThisWeek')), const SizedBox(width:12), Expanded(child:StatCard(title:'Calories today', value:'$calories / 2100'))]),
        const SizedBox(height:12), const StatCard(title:'Streak', value:'4 days', subtitle:'Keep it up!'),
        const SizedBox(height:16),
        Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height:8),
        Wrap(spacing:12, children:[
          ElevatedButton.icon(onPressed: ()=>Navigator.of(context).pushNamed('/workout/new'), icon: const Icon(Icons.fitness_center), label: const Text('Add Workout')),
          ElevatedButton.icon(onPressed: ()=>Navigator.of(context).pushNamed('/calories'), icon: const Icon(Icons.restaurant), label: const Text('Add Meal')),
          ElevatedButton.icon(onPressed: ()=>Navigator.of(context).pushNamed('/routines'), icon: const Icon(Icons.flag_outlined), label: const Text('Start Routine')),
        ])
      ]),
=======
import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final workoutsThisWeek = app.workouts.where((w){
      final now = DateTime.now();
      final sow = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday-1));
      return w.dateTime.isAfter(sow);
    }).length;
    final calories = app.caloriesToday;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Fitness Tracker'),
          backgroundColor: Colors.black.withOpacity(0.2),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.emoji_events_outlined),
              onPressed: () => Navigator.of(context).pushNamed('/badges'),
              tooltip: 'Badges',
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.of(context).pushNamed('/settings'),
              tooltip: 'Settings',
            ),
          ],
        ),
        body: app.loading && !app.bootstrapped
            ? const Center(child: CircularProgressIndicator())
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Streak banner
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF43CEA2), Color(0xFF185A9D)]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 8))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Streak: ${app.streakDays} day${app.streakDays == 1 ? '' : 's'} 🔥',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () => Navigator.of(context).pushNamed('/badges'),
                    child: const Text('View Badges'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Today section
            Text('Today', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: StatCard(title: 'Workouts this week', value: '$workoutsThisWeek')),
                const SizedBox(width: 12),
                Expanded(child: StatCard(title: 'Calories today', value: '$calories / ${app.dailyCalorieGoal}')),
              ],
            ),
            const SizedBox(height: 12),
            const StatCard(title: 'Keep Going', value: 'You got this!', subtitle: 'Consistency > perfection'),

            const SizedBox(height: 16),
            Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/workout/new'),
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Add Workout'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/calories'),
                  icon: const Icon(Icons.restaurant),
                  label: const Text('Add Meal'),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/routines'),
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Start Routine'),
                ),
              ],
            ),
          ],
        ),
      ),
>>>>>>> fe0a9a2 (Milestone 2)
    );
  }
}
