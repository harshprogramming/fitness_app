
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
    );
  }
}
