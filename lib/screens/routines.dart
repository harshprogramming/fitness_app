<<<<<<< HEAD

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
=======
import 'package:flutter/material.dart';
import '../models/routine.dart';
import '../state/app_scope.dart';
import '../data/routines.dart' as presets;

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    // Combine presets + custom (AppState loads custom from SQLite)
    final all = app.routines.isEmpty ? presets.routines : app.routines;

    // Group by category
    final Map<RoutineCategory, List<Routine>> grouped = {};
    for (final r in all) {
      grouped.putIfAbsent(r.category, () => []).add(r);
    }

    String catName(RoutineCategory c) => switch (c) {
      RoutineCategory.yoga => 'Yoga',
      RoutineCategory.cycling => 'Cycling',
      RoutineCategory.weightlifting => 'Weightlifting',
      RoutineCategory.running => 'Running',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Routines')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (_) => const _CustomRoutineForm(),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Create Custom Routine'),
          ),
          const SizedBox(height: 16),

          ...grouped.entries.map((e) {
            final items = e.value..sort((a, b) => a.level.index.compareTo(b.level.index));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(catName(e.key), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...items.map((r) => _RoutineTile(
                  routine: r,
                  onDelete: r.isCustom ? () => app.deleteCustomRoutine(r.id) : null,
                )),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _RoutineTile extends StatelessWidget {
  const _RoutineTile({required this.routine, this.onDelete});
  final Routine routine;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text('${routine.title} • ${routine.levelLabel}'),
        subtitle: Text('${routine.focus} • ~${routine.durationMin} min'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete',
                onPressed: onDelete,
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => showModalBottomSheet(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (_) => _RoutineDetails(routine: routine),
        ),
      ),
    );
  }
}

class _RoutineDetails extends StatelessWidget {
  const _RoutineDetails({required this.routine});
  final Routine routine;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${routine.categoryLabel} • ${routine.levelLabel}',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 6),
              Text(routine.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(routine.focus),
              const SizedBox(height: 12),
              ...routine.steps.map((s) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(s)),
                  ],
                ),
              )),
              if (routine.notes != null) ...[
                const SizedBox(height: 12),
                Text('Notes: ${routine.notes!}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomRoutineForm extends StatefulWidget {
  const _CustomRoutineForm();

  @override
  State<_CustomRoutineForm> createState() => _CustomRoutineFormState();
}

class _CustomRoutineFormState extends State<_CustomRoutineForm> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _focus = TextEditingController();
  final _notes = TextEditingController();
  final _duration = TextEditingController(text: '30');

  RoutineCategory _category = RoutineCategory.yoga;
  RoutineLevel _level = RoutineLevel.beginner;

  final List<TextEditingController> _steps = [TextEditingController()];

  @override
  void dispose() {
    _title.dispose();
    _focus.dispose();
    _notes.dispose();
    _duration.dispose();
    for (final c in _steps) { c.dispose(); } // braces ✅
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Create Custom Routine',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),

                // Title
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
                ),

                // Category + Level (use initialValue)
                const SizedBox(height: 8),
                DropdownButtonFormField<RoutineCategory>(
                  initialValue: _category, // ✅
                  items: RoutineCategory.values
                      .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c.name[0].toUpperCase() + c.name.substring(1),
                    ),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v ?? _category),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<RoutineLevel>(
                  initialValue: _level, // ✅
                  items: RoutineLevel.values
                      .map((l) => DropdownMenuItem(
                    value: l,
                    child: Text(
                      l.name[0].toUpperCase() + l.name.substring(1),
                    ),
                  ))
                      .toList(),
                  onChanged: (v) => setState(() => _level = v ?? _level),
                  decoration: const InputDecoration(labelText: 'Level'),
                ),

                // Duration, Focus, Notes
                const SizedBox(height: 8),
                TextFormField(
                  controller: _duration,
                  decoration:
                  const InputDecoration(labelText: 'Duration (minutes)'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n <= 0) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _focus,
                  decoration:
                  const InputDecoration(labelText: 'Focus / short summary'),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a short focus' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notes,
                  decoration:
                  const InputDecoration(labelText: 'Notes (optional)'),
                ),

                // Steps (dynamic)
                const SizedBox(height: 12),
                Text('Steps', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                ..._steps.asMap().entries.map((e) { // no .toList() ✅
                  final idx = e.key;
                  final ctrl = e.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: ctrl,
                            decoration:
                            InputDecoration(labelText: 'Step ${idx + 1}'),
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Enter a step' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _steps.length > 1
                              ? () => setState(() => _steps.removeAt(idx))
                              : null,
                        ),
                      ],
                    ),
                  );
                }),

                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () =>
                        setState(() => _steps.add(TextEditingController())),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Step'),
                  ),
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Routine'),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      final steps = _steps
                          .map((c) => c.text.trim())
                          .where((s) => s.isNotEmpty)
                          .toList();

                      final r = Routine(
                        id: '',
                        title: _title.text.trim(),
                        category: _category,
                        level: _level,
                        durationMin: int.parse(_duration.text.trim()),
                        focus: _focus.text.trim(),
                        steps: steps,
                        notes:
                        _notes.text.trim().isEmpty ? null : _notes.text.trim(),
                        isCustom: true, // ✅ now defined on model
                      );

                      await app.addCustomRoutine(r);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
>>>>>>> fe0a9a2 (Milestone 2)
}
