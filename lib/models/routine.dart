enum RoutineCategory { yoga, cycling, weightlifting, running }
enum RoutineLevel { beginner, intermediate, advanced }

class Routine {
  const Routine({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.durationMin,
    required this.focus,
    required this.steps,
    this.notes,
    this.isCustom = false, // <-- needed by the screen to enable Delete, etc.
  });

  final String id;
  final String title;
  final RoutineCategory category;
  final RoutineLevel level;
  final int durationMin;
  final String focus;
  final List<String> steps;
  final String? notes;
  final bool isCustom;

  String get levelLabel => switch (level) {
    RoutineLevel.beginner => 'Beginner',
    RoutineLevel.intermediate => 'Intermediate',
    RoutineLevel.advanced => 'Advanced',
  };

  String get categoryLabel => switch (category) {
    RoutineCategory.yoga => 'Yoga',
    RoutineCategory.cycling => 'Cycling',
    RoutineCategory.weightlifting => 'Weightlifting',
    RoutineCategory.running => 'Running',
  };
}
