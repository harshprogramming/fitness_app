
import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../models/workout.dart';
class WorkoutsScreen extends StatelessWidget{
  const WorkoutsScreen({super.key});
  @override
  Widget build(BuildContext context){
    final app = AppScope.of(context);
    final items = List<Workout>.from(app.workouts)..sort((a,b)=>b.dateTime.compareTo(a.dateTime));
    return Scaffold(appBar: AppBar(title: const Text('Workouts'), actions:[IconButton(icon: const Icon(Icons.add), onPressed: ()=>Navigator.of(context).pushNamed('/workout/new'))]),
      body: ListView.separated(itemCount: items.length, separatorBuilder: (_, __)=>const Divider(height:0), itemBuilder:(context,i){ final w=items[i]; return ListTile(
        title: Text(w.type),
        subtitle: Text('${w.durationMin} min  •  ${_fmt(w.dateTime)}' '${w.distanceKm!=null ? '  •  ${w.distanceKm!.toStringAsFixed(1)} km' : ''}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: ()=>Navigator.of(context).pushNamed('/workout/edit', arguments:w),
      );}),
      floatingActionButton: FloatingActionButton(onPressed: ()=>Navigator.of(context).pushNamed('/workout/new'), child: const Icon(Icons.add)),
    );
  }
  String _fmt(DateTime d)=>'${d.year}-${d.month.toString().padLeft(2,'0')}-${d.day.toString().padLeft(2,'0')} ${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
}
