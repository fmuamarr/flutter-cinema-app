class MovieReminder {
  final int id;
  final int filmId;
  final String filmTitle;
  final DateTime showTime;
  final DateTime reminderTime;
  final int offsetMinutes;
  final String? note;
  final String? posterPath;
  final DateTime createdAt;

  const MovieReminder({
    required this.id,
    required this.filmId,
    required this.filmTitle,
    required this.showTime,
    required this.reminderTime,
    this.offsetMinutes = 0,
    this.note,
    this.posterPath,
    required this.createdAt,
  });

  bool get isPast => reminderTime.isBefore(DateTime.now());

  factory MovieReminder.fromJson(Map<String, dynamic> json) {
    return MovieReminder(
      id: json['id'] as int,
      filmId: json['film_id'] as int,
      filmTitle: json['film_title'] as String? ?? '',
      showTime: DateTime.tryParse(json['show_time'] as String? ?? '') ??
          DateTime.now(),
      reminderTime:
          DateTime.tryParse(json['reminder_time'] as String? ?? '') ??
              DateTime.now(),
      offsetMinutes: json['offset_minutes'] as int? ?? 0,
      note: json['note'] as String?,
      posterPath: json['poster_path'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'film_id': filmId,
      'film_title': filmTitle,
      'show_time': showTime.toIso8601String(),
      'reminder_time': reminderTime.toIso8601String(),
      'offset_minutes': offsetMinutes,
      'note': note,
      'poster_path': posterPath,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
