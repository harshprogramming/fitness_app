
import 'package:flutter/material.dart';
import 'state/app_state.dart';
import 'state/app_scope.dart';
import 'services/repository.dart';
import 'screens/home.dart';
import 'screens/workouts.dart';
import 'screens/workout_form.dart';
import 'screens/calories.dart';
import 'screens/progress.dart';
import 'screens/routines.dart';
import 'screens/settings.dart';
import 'models/workout.dart';

void main(){
  final appState = AppState(Repository());
  runApp(FitnessApp(appState: appState));
}
class FitnessApp extends StatefulWidget{
  const FitnessApp({super.key, required this.appState});
  final AppState appState;
  @override State<FitnessApp> createState()=>_FitnessAppState();
}
class _FitnessAppState extends State<FitnessApp>{
  int _index=0;
  @override Widget build(BuildContext context){
    return AppScope(notifier: widget.appState, child: MaterialApp(
      title:'Fitness Tracker', debugShowCheckedModeBanner:false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), useMaterial3:true),
      routes:{
        '/': (_)=>_Root(index:_index, onIndex:(i)=>setState(()=>_index=i)),
        '/workout/new': (_)=> const WorkoutFormScreen(),
        '/workout/edit': (ctx){ final w = ModalRoute.of(ctx)!.settings.arguments as Workout; return WorkoutFormScreen(existing:w); },
        '/calories': (_)=> const CaloriesScreen(),
        '/routines': (_)=> const RoutinesScreen(),
        '/settings': (_)=> const SettingsScreen(),
      },
      onUnknownRoute: (_)=>MaterialPageRoute(builder: (_)=> const HomeScreen()),
    ));
  }
}
class _Root extends StatelessWidget{
  const _Root({required this.index, required this.onIndex});
  final int index; final ValueChanged<int> onIndex;
  @override Widget build(BuildContext context){
    final pages = const [HomeScreen(), WorkoutsScreen(), CaloriesScreen(), ProgressScreen()];
    return Scaffold(body: IndexedStack(index:index, children: pages),
      bottomNavigationBar: NavigationBar(selectedIndex:index, destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label:'Home'),
        NavigationDestination(icon: Icon(Icons.fitness_center_outlined), label:'Workouts'),
        NavigationDestination(icon: Icon(Icons.restaurant_outlined), label:'Calories'),
        NavigationDestination(icon: Icon(Icons.show_chart_outlined), label:'Progress'),
      ], onDestinationSelected:onIndex),
    );
  }
}
