class RoutePoint {
  final double latitude;
  final double longitude;

  const RoutePoint(this.latitude, this.longitude);
}

class CinemaRouteEntity {
  final List<RoutePoint> points;
  final double distanceMeters;
  final double durationSeconds;
  final String? summary;

  CinemaRouteEntity({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
    this.summary,
  });

  double get distanceInKm => distanceMeters / 1000.0;
  int get durationMinutes => (durationSeconds / 60.0).round();

  String get distanceFormatted {
    if (distanceInKm < 1.0) {
      return '${distanceMeters.round()} m';
    }
    return '${distanceInKm.toStringAsFixed(1)} km';
  }

  String get durationFormatted {
    final mins = durationMinutes;
    if (mins < 60) {
      return '$mins min';
    }
    final hours = mins ~/ 60;
    final remainingMins = mins % 60;
    return remainingMins > 0 ? '${hours}h ${remainingMins}m' : '${hours}h';
  }
}
