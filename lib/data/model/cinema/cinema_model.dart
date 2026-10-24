class CinemaModel {
  final String? id;
  final String? name;
  final String? city;
  final String? chain;
  final String? address;
  final double? latitude;
  final double? longitude;

  CinemaModel({
    this.id,
    this.name,
    this.city,
    this.chain,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory CinemaModel.fromJson(Map<String, dynamic> json) {
    return CinemaModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      city: json['city'] as String?,
      chain: json['chain'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'city': city,
    'chain': chain,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
  };
}
