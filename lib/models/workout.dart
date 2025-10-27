<<<<<<< HEAD

=======
>>>>>>> fe0a9a2 (Milestone 2)
class Workout {
  Workout({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.durationMin,
    this.distanceKm,
    this.strengthNotes,
    this.notes,
  });
<<<<<<< HEAD
=======

>>>>>>> fe0a9a2 (Milestone 2)
  final String id;
  final String type;
  final DateTime dateTime;
  final int durationMin;
  final double? distanceKm;
  final String? strengthNotes;
  final String? notes;
<<<<<<< HEAD
  Workout copyWith({String? id,String? type,DateTime? dateTime,int? durationMin,double? distanceKm,String? strengthNotes,String? notes}){
=======

  Workout copyWith({
    String? id,
    String? type,
    DateTime? dateTime,
    int? durationMin,
    double? distanceKm,
    String? strengthNotes,
    String? notes,
  }) {
>>>>>>> fe0a9a2 (Milestone 2)
    return Workout(
      id: id ?? this.id,
      type: type ?? this.type,
      dateTime: dateTime ?? this.dateTime,
      durationMin: durationMin ?? this.durationMin,
      distanceKm: distanceKm ?? this.distanceKm,
      strengthNotes: strengthNotes ?? this.strengthNotes,
      notes: notes ?? this.notes,
    );
  }
<<<<<<< HEAD
=======

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'dateTime': dateTime.toIso8601String(),
    'durationMin': durationMin,
    'distanceKm': distanceKm,
    'strengthNotes': strengthNotes,
    'notes': notes,
  };

  static Workout fromJson(Map<String, dynamic> json) => Workout(
    id: json['id'] as String,
    type: json['type'] as String,
    dateTime: DateTime.parse(json['dateTime'] as String),
    durationMin: (json['durationMin'] as num).toInt(),
    distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    strengthNotes: json['strengthNotes'] as String?,
    notes: json['notes'] as String?,
  );
>>>>>>> fe0a9a2 (Milestone 2)
}
