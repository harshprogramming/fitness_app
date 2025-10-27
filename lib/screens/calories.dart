
import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../models/meal_entry.dart';
class CaloriesScreen extends StatelessWidget{
  const CaloriesScreen({super.key});
  @override Widget build(BuildContext context){
    final app = AppScope.of(context); final total=app.caloriesToday; final remaining=(app.dailyCalorieGoal-total).clamp(0,99999);
    final meals = app.mealsForSelectedDate;
    void addFor(MealType t){ showModalBottomSheet(context: context, showDragHandle:true, isScrollControlled:true, builder:(ctx)=>_AddFoodSheet(type:t)); }
    return Scaffold(appBar: AppBar(title: const Text('Calories'), actions:[IconButton(icon: const Icon(Icons.calendar_today_outlined), onPressed: () async {
      final d=await showDatePicker(context: context, initialDate: app.selectedDate, firstDate: DateTime(2022), lastDate: DateTime(2100)); if(d!=null) app.setSelectedDate(d);
    })]),
      body: ListView(padding: const EdgeInsets.all(16), children:[
        Card(child:Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
          Text('Daily Goal: ${app.dailyCalorieGoal} kcal'), const SizedBox(height:8),
          Text('Consumed: $total kcal   •   Remaining: $remaining kcal'),
        ]))),
        _section(context,'Breakfast', MealType.breakfast, meals, addFor, (id)=>app.removeMeal(id)),
        _section(context,'Lunch', MealType.lunch, meals, addFor, (id)=>app.removeMeal(id)),
        _section(context,'Dinner', MealType.dinner, meals, addFor, (id)=>app.removeMeal(id)),
        _section(context,'Snacks', MealType.snacks, meals, addFor, (id)=>app.removeMeal(id)),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: ()=>addFor(MealType.snacks), child: const Icon(Icons.add)),
    );
  }
  Widget _section(BuildContext context, String title, MealType type, List<MealEntry> all, Function(MealType) onAdd, Function(String) onRemove){
    final items = all.where((e)=>e.mealType==type).toList();
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Text(title, style: Theme.of(context).textTheme.titleMedium), IconButton(icon: const Icon(Icons.add), onPressed: ()=>onAdd(type))]),
      ...items.map((e)=>ListTile(dense:true, title: Text(e.name), subtitle: e.serving!=null?Text(e.serving!):null, trailing: Row(mainAxisSize: MainAxisSize.min, children:[Text('${e.calories} kcal'), IconButton(icon: const Icon(Icons.delete_outline), onPressed: ()=>onRemove(e.id))]))),
      if(items.isEmpty) Padding(padding: const EdgeInsets.only(top:8), child: Text('No items', style: Theme.of(context).textTheme.bodySmall)),
    ])));
  }
}
class _AddFoodSheet extends StatefulWidget{ const _AddFoodSheet({required this.type}); final MealType type; @override State<_AddFoodSheet> createState()=>_AddFoodSheetState(); }
class _AddFoodSheetState extends State<_AddFoodSheet>{
  final _formKey=GlobalKey<FormState>(); final _name=TextEditingController(); final _cal=TextEditingController(); final _serv=TextEditingController();
  @override void dispose(){ _name.dispose(); _cal.dispose(); _serv.dispose(); super.dispose(); }
  @override Widget build(BuildContext context){
    final app = AppScope.of(context);
    return Padding(padding: EdgeInsets.only(left:16,right:16,top:16,bottom: MediaQuery.of(context).viewInsets.bottom+16),
      child: Form(key:_formKey, child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children:[
        Text('Add Food', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height:8),
        TextFormField(controller:_name, decoration: const InputDecoration(labelText:'Name'), validator:(v)=>(v==null||v.trim().isEmpty)?'Enter a name':null),
        TextFormField(controller:_cal, decoration: const InputDecoration(labelText:'Calories (kcal)'), keyboardType: TextInputType.number, validator:(v){ final n=int.tryParse(v??''); if(n==null||n<=0) return 'Enter calories'; return null; }),
        TextFormField(controller:_serv, decoration: const InputDecoration(labelText:'Serving size (optional)')),
        const SizedBox(height:12),
        Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: (){
          if(!_formKey.currentState!.validate()) return;
          app.addMeal(MealEntry(id:'tmp', date: app.selectedDate, mealType: widget.type, name: _name.text.trim(), calories: int.parse(_cal.text.trim()), serving: _serv.text.trim().isEmpty? null : _serv.text.trim()));
          Navigator.of(context).pop();
        }, child: const Text('Save')))
      ])));
  }
}
