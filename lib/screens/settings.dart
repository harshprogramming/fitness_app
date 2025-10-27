
import 'package:flutter/material.dart';
class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: const Text('Settings')),
      body: ListView(children: const [
        ListTile(title: Text('Units'), subtitle: Text('Metric / Imperial')),
        ListTile(title: Text('Calorie Goal'), subtitle: Text('2100 kcal')),
        ListTile(title: Text('Theme'), subtitle: Text('System')),
        ListTile(title: Text('Export Data'), subtitle: Text('Coming soon')),
      ]),
    );
  }
}
