
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
  final String id;
  final String type;
  final DateTime dateTime;
  final int durationMin;
  final double? distanceKm;
  final String? strengthNotes;
  final String? notes;
  Workout copyWith({String? id,String? type,DateTime? dateTime,int? durationMin,double? distanceKm,String? strengthNotes,String? notes}){
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
}
