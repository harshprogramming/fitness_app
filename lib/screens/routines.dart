
import 'package:flutter/material.dart';
class RoutinesScreen extends StatelessWidget{
  const RoutinesScreen({super.key});
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text('Routines')),
      body: ListView(padding: const EdgeInsets.all(16), children:[
        _tile(context,'Beginner Plan','3 days/week • 4 weeks'),
        _tile(context,'Intermediate Plan','4 days/week • 6 weeks'),
        _tile(context,'Advanced Plan','5 days/week • 8 weeks'),
        const SizedBox(height:12),
        OutlinedButton.icon(onPressed:(){}, icon: const Icon(Icons.add), label: const Text('Custom Routine'))
      ]),
    );
  }
  Widget _tile(BuildContext context, String t, String s)=>Card(child: ListTile(title: Text(t), subtitle: Text(s), trailing: const Icon(Icons.play_arrow), onTap: (){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Started $t (demo)')));
  }));
}
