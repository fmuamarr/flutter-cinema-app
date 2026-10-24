class CinemaEntity {
  final String id;
  final String name;
  final String city;
  final String chain;
  final String address;
  final double latitude;
  final double longitude;
  final double? distanceInKm;
  final int? etaMinutes;

  CinemaEntity({
    required this.id,
    required this.name,
    required this.city,
    required this.chain,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distanceInKm,
    this.etaMinutes,
  });

  CinemaEntity copyWith({
    String? id,
    String? name,
    String? city,
    String? chain,
    String? address,
    double? latitude,
    double? longitude,
    double? distanceInKm,
    int? etaMinutes,
  }) {
    return CinemaEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      chain: chain ?? this.chain,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }

  String get distanceFormatted {
    if (distanceInKm == null) return '-- km';
    if (distanceInKm! < 1.0) {
      return '${(distanceInKm! * 1000).round()} m';
    }
    return '${distanceInKm!.toStringAsFixed(1)} km';
  }

  String get etaFormatted {
    if (etaMinutes == null) return '-- min';
    if (etaMinutes! < 60) {
      return '$etaMinutes min';
    }
    final hours = etaMinutes! ~/ 60;
    final mins = etaMinutes! % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }
}
