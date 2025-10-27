<<<<<<< HEAD

import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../models/workout.dart';
class WorkoutFormScreen extends StatefulWidget{
  const WorkoutFormScreen({super.key, this.existing});
  final Workout? existing;
  @override State<WorkoutFormScreen> createState()=>_WorkoutFormScreenState();
}
class _WorkoutFormScreenState extends State<WorkoutFormScreen>{
  final _formKey = GlobalKey<FormState>();
  late String _type; late DateTime _dateTime; int _duration=30; double? _distance; String? _strengthNotes; String? _notes;
  final _opts = const ['Running','Cycling','Weightlifting','Yoga','Other'];
  @override void initState(){ super.initState(); final w=widget.existing; _type=w?.type ?? 'Running'; _dateTime=w?.dateTime ?? DateTime.now(); _duration=w?.durationMin ?? 30; _distance=w?.distanceKm; _strengthNotes=w?.strengthNotes; _notes=w?.notes; }
  @override Widget build(BuildContext context){
    final app = AppScope.of(context); final isEdit = widget.existing!=null;
    return Scaffold(appBar: AppBar(title: Text(isEdit? 'Edit Workout':'Add Workout'), actions:[TextButton(onPressed:_save, child: const Text('Save'))]),
      body: Form(key:_formKey, child: ListView(padding: const EdgeInsets.all(16), children:[
        DropdownButtonFormField<String>(value:_type, items:_opts.map((t)=>DropdownMenuItem(value:t, child:Text(t))).toList(), onChanged:(v)=>setState(()=>_type=v??_type), decoration: const InputDecoration(labelText:'Type')),
        const SizedBox(height:8),
        ListTile(contentPadding: EdgeInsets.zero, title: const Text('Date & Time'), subtitle: Text(_dateTime.toString()), trailing: const Icon(Icons.calendar_today), onTap:_pickDateTime),
        TextFormField(initialValue:_duration.toString(), decoration: const InputDecoration(labelText:'Duration (min)'), keyboardType: TextInputType.number, validator:(v){final n=int.tryParse(v??''); if(n==null||n<=0)return 'Enter minutes'; return null;}, onSaved:(v)=>_duration=int.parse(v!)),
        if(_type=='Running'||_type=='Cycling') TextFormField(initialValue:_distance?.toString()??'', decoration: const InputDecoration(labelText:'Distance (km)'), keyboardType: const TextInputType.numberWithOptions(decimal:true), onSaved:(v)=>_distance=v!.isEmpty?null:double.tryParse(v)),
        if(_type=='Weightlifting') TextFormField(initialValue:_strengthNotes??'', decoration: const InputDecoration(labelText:'Reps/Sets'), onSaved:(v)=>_strengthNotes=v!.isEmpty?null:v),
        TextFormField(initialValue:_notes??'', decoration: const InputDecoration(labelText:'Notes'), onSaved:(v)=>_notes=v!.isEmpty?null:v),
        if(isEdit)...[const SizedBox(height:16), OutlinedButton.icon(icon: const Icon(Icons.delete_outline), label: const Text('Delete'), onPressed: (){ app.removeWorkout(widget.existing!.id); Navigator.of(context).pop(); })]
      ])),
    );
  }
  Future<void> _pickDateTime() async {
    final d = await showDatePicker(context: context, initialDate: _dateTime, firstDate: DateTime(2022), lastDate: DateTime(2100));
    if(d==null) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(_dateTime));
    if(t==null) return;
    setState(()=>_dateTime=DateTime(d.year,d.month,d.day,t.hour,t.minute));
  }
  void _save(){
    if(!_formKey.currentState!.validate()) return; _formKey.currentState!.save();
    final app = AppScope.of(context);
    if(widget.existing==null){
      app.addWorkout(Workout(id:'tmp', type:_type, dateTime:_dateTime, durationMin:_duration, distanceKm:_distance, strengthNotes:_strengthNotes, notes:_notes));
    } else {
      app.updateWorkout(widget.existing!.copyWith(type:_type, dateTime:_dateTime, durationMin:_duration, distanceKm:_distance, strengthNotes:_strengthNotes, notes:_notes));
    }
    Navigator.of(context).pop();
=======
import 'package:flutter/material.dart';
import '../state/app_scope.dart';
import '../models/workout.dart';

class WorkoutFormScreen extends StatefulWidget {
  const WorkoutFormScreen({super.key, this.existing});
  final Workout? existing;

  @override
  State<WorkoutFormScreen> createState() => _WorkoutFormScreenState();
}

class _WorkoutFormScreenState extends State<WorkoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late DateTime _dateTime;
  int _duration = 30;
  double? _distance;
  String? _strengthNotes;
  String? _notes;

  final _opts = const ['Running', 'Cycling', 'Weightlifting', 'Yoga', 'Other'];

  @override
  void initState() {
    super.initState();
    final w = widget.existing;
    _type = w?.type ?? 'Running';
    _dateTime = w?.dateTime ?? DateTime.now();
    _duration = w?.durationMin ?? 30;
    _distance = w?.distanceKm;
    _strengthNotes = w?.strengthNotes;
    _notes = w?.notes;
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Workout' : 'Add Workout'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _type,
              items: _opts.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (v) => setState(() => _type = v ?? _type),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date & Time'),
              subtitle: Text(_dateTime.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            TextFormField(
              initialValue: _duration.toString(),
              decoration: const InputDecoration(labelText: 'Duration (min)'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n <= 0) return 'Enter minutes';
                return null;
              },
              onSaved: (v) => _duration = int.parse(v!),
            ),
            if (_type == 'Running' || _type == 'Cycling')
              TextFormField(
                initialValue: _distance?.toString() ?? '',
                decoration: const InputDecoration(labelText: 'Distance (km)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSaved: (v) => _distance = v!.isEmpty ? null : double.tryParse(v),
              ),
            if (_type == 'Weightlifting')
              TextFormField(
                initialValue: _strengthNotes ?? '',
                decoration: const InputDecoration(labelText: 'Reps/Sets'),
                onSaved: (v) => _strengthNotes = v!.isEmpty ? null : v,
              ),
            TextFormField(
              initialValue: _notes ?? '',
              decoration: const InputDecoration(labelText: 'Notes'),
              onSaved: (v) => _notes = v!.isEmpty ? null : v,
            ),
            if (isEdit) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
                onPressed: () async {
                  await app.removeWorkout(widget.existing!.id);
                  if (mounted) Navigator.of(context).pop();
                },
              )
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (t == null) return;
    setState(() => _dateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final app = AppScope.of(context);
    if (widget.existing == null) {
      await app.addWorkout(Workout(
        id: '', // repo assigns an id
        type: _type,
        dateTime: _dateTime,
        durationMin: _duration,
        distanceKm: _distance,
        strengthNotes: _strengthNotes,
        notes: _notes,
      ));
    } else {
      await app.updateWorkout(widget.existing!.copyWith(
        type: _type,
        dateTime: _dateTime,
        durationMin: _duration,
        distanceKm: _distance,
        strengthNotes: _strengthNotes,
        notes: _notes,
      ));
    }
    if (mounted) Navigator.of(context).pop();
>>>>>>> fe0a9a2 (Milestone 2)
  }
}
