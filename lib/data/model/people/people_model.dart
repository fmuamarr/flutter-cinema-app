class PeopleModel {
  String? name;
  String? height;
  String? mass;
  String? hairColor;
  String? skinColor;
  String? eyeColor;
  String? birthYear;
  String? gender;
  String? homeworld;
  List<String>? films;
  List<dynamic>? species;
  List<String>? vehicles;
  List<String>? starships;
  DateTime? created;
  DateTime? edited;
  String? url;

  PeopleModel({
    this.name,
    this.height,
    this.mass,
    this.hairColor,
    this.skinColor,
    this.eyeColor,
    this.birthYear,
    this.gender,
    this.homeworld,
    this.films,
    this.species,
    this.vehicles,
    this.starships,
    this.created,
    this.edited,
    this.url,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) => PeopleModel(
    name: json['name'],
    height: json['height'],
    mass: json['mass'],
    hairColor: json['hair_color'],
    skinColor: json['skin_color'],
    eyeColor: json['eye_color'],
    birthYear: json['birth_year'],
    gender: json['gender'],
    homeworld: json['homeworld'],
    films: json['films'] == null
        ? []
        : List<String>.from(json['films']!.map((x) => x)),
    species: json['species'] == null
        ? []
        : List<dynamic>.from(json['species']!.map((x) => x)),
    vehicles: json['vehicles'] == null
        ? []
        : List<String>.from(json['vehicles']!.map((x) => x)),
    starships: json['starships'] == null
        ? []
        : List<String>.from(json['starships']!.map((x) => x)),
    created: json['created'] == null ? null : DateTime.parse(json['created']),
    edited: json['edited'] == null ? null : DateTime.parse(json['edited']),
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'height': height,
    'mass': mass,
    'hair_color': hairColor,
    'skin_color': skinColor,
    'eye_color': eyeColor,
    'birth_year': birthYear,
    'gender': gender,
    'homeworld': homeworld,
    'films': films == null ? [] : List<dynamic>.from(films!.map((x) => x)),
    'species': species == null
        ? []
        : List<dynamic>.from(species!.map((x) => x)),
    'vehicles': vehicles == null
        ? []
        : List<dynamic>.from(vehicles!.map((x) => x)),
    'starships': starships == null
        ? []
        : List<dynamic>.from(starships!.map((x) => x)),
    'created': created?.toIso8601String(),
    'edited': edited?.toIso8601String(),
    'url': url,
  };
}
