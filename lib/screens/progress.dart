
import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../widgets/simple_chart.dart';
class ProgressScreen extends StatelessWidget{
  const ProgressScreen({super.key});
  @override Widget build(BuildContext context){
    final app = AppScope.of(context);
    final now = DateTime.now();
    final labels = List<String>.generate(7,(i){ final d=now.subtract(Duration(days:6-i)); return '${d.month}/${d.day}'; });
    final workouts = List<double>.generate(7,(i)=>0);
    for(final w in app.workouts){ final diff = now.difference(DateTime(w.dateTime.year,w.dateTime.month,w.dateTime.day)).inDays; if(diff>=0 && diff<7){ workouts[6-diff]+=1; } }
    final calories = List<double>.generate(7,(i)=>0);
    for(var i=0;i<7;i++){ final d=now.subtract(Duration(days:6-i)); calories[i]=app.repo.caloriesForDate(d).toDouble(); }
    return Scaffold(appBar: AppBar(title: const Text('Progress')),
      body: ListView(padding: const EdgeInsets.all(16), children:[
        Text('Workouts per day (last 7 days)', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height:8),
        SimpleBarChart(values: workouts, labels: labels),
        const SizedBox(height:16),
        Text('Calories per day (last 7 days)', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height:8),
        SimpleBarChart(values: calories, labels: labels),
      ]),
    );
  }
}
