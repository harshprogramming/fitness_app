class Badge {
  Badge({
    required this.code,
    required this.title,
    required this.description,
    this.earnedAt,
  });

  final String code;          // e.g. 'first_workout'
  final String title;         // e.g. 'First Workout'
  final String description;   // short blurb
  final DateTime? earnedAt;   // null => locked

  bool get earned => earnedAt != null;

  Badge copyWith({DateTime? earnedAt}) => Badge(
    code: code,
    title: title,
    description: description,
    earnedAt: earnedAt ?? this.earnedAt,
  );

  static Badge fromRow(Map<String, dynamic> row) => Badge(
    code: row['code'] as String,
    title: row['title'] as String,
    description: row['description'] as String,
    earnedAt: row['earnedAt'] == null ? null : DateTime.parse(row['earnedAt'] as String),
  );
}
