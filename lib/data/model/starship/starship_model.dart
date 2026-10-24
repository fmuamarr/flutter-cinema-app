class StarshipModel {
  String? name;
  String? model;
  String? manufacturer;
  String? costInCredits;
  String? length;
  String? maxAtmospheringSpeed;
  String? crew;
  String? passengers;
  String? cargoCapacity;
  String? consumables;
  String? hyperdriveRating;
  String? mglt;
  String? starshipClass;
  List<dynamic>? pilots;
  List<String>? films;
  DateTime? created;
  DateTime? edited;
  String? url;

  StarshipModel({
    this.name,
    this.model,
    this.manufacturer,
    this.costInCredits,
    this.length,
    this.maxAtmospheringSpeed,
    this.crew,
    this.passengers,
    this.cargoCapacity,
    this.consumables,
    this.hyperdriveRating,
    this.mglt,
    this.starshipClass,
    this.pilots,
    this.films,
    this.created,
    this.edited,
    this.url,
  });

  factory StarshipModel.fromJson(Map<String, dynamic> json) => StarshipModel(
    name: json['name'],
    model: json['model'],
    manufacturer: json['manufacturer'],
    costInCredits: json['cost_in_credits'],
    length: json['length'],
    maxAtmospheringSpeed: json['max_atmosphering_speed'],
    crew: json['crew'],
    passengers: json['passengers'],
    cargoCapacity: json['cargo_capacity'],
    consumables: json['consumables'],
    hyperdriveRating: json['hyperdrive_rating'],
    mglt: json['MGLT'],
    starshipClass: json['starship_class'],
    pilots: json['pilots'] == null
        ? []
        : List<dynamic>.from(json['pilots']!.map((x) => x)),
    films: json['films'] == null
        ? []
        : List<String>.from(json['films']!.map((x) => x)),
    created: json['created'] == null ? null : DateTime.parse(json['created']),
    edited: json['edited'] == null ? null : DateTime.parse(json['edited']),
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'model': model,
    'manufacturer': manufacturer,
    'cost_in_credits': costInCredits,
    'length': length,
    'max_atmosphering_speed': maxAtmospheringSpeed,
    'crew': crew,
    'passengers': passengers,
    'cargo_capacity': cargoCapacity,
    'consumables': consumables,
    'hyperdrive_rating': hyperdriveRating,
    'MGLT': mglt,
    'starship_class': starshipClass,
    'pilots': pilots == null ? [] : List<dynamic>.from(pilots!.map((x) => x)),
    'films': films == null ? [] : List<dynamic>.from(films!.map((x) => x)),
    'created': created?.toIso8601String(),
    'edited': edited?.toIso8601String(),
    'url': url,
  };
}
