<<<<<<< HEAD

import 'package:flutter/material.dart';
class StatCard extends StatelessWidget{
  const StatCard({super.key, required this.title, required this.value, this.subtitle});
  final String title; final String value; final String? subtitle;
  @override
  Widget build(BuildContext context){
    return Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment: CrossAxisAlignment.start,children:[
      Text(title,style:Theme.of(context).textTheme.titleMedium),
      const SizedBox(height:8),
      Text(value,style:Theme.of(context).textTheme.headlineSmall),
      if(subtitle!=null)...[const SizedBox(height:4),Text(subtitle!,style:Theme.of(context).textTheme.bodySmall)]
    ])));
=======
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.title, required this.value, this.subtitle});
  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ]
        ],
      ),
    );
>>>>>>> fe0a9a2 (Milestone 2)
  }
}
