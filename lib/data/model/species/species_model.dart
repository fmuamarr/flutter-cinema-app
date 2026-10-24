class SpeciesModel {
  String? name;
  String? classification;
  String? designation;
  String? averageHeight;
  String? skinColors;
  String? hairColors;
  String? eyeColors;
  String? averageLifespan;
  String? homeworld;
  String? language;
  List<String>? people;
  List<String>? films;
  DateTime? created;
  DateTime? edited;
  String? url;

  SpeciesModel({
    this.name,
    this.classification,
    this.designation,
    this.averageHeight,
    this.skinColors,
    this.hairColors,
    this.eyeColors,
    this.averageLifespan,
    this.homeworld,
    this.language,
    this.people,
    this.films,
    this.created,
    this.edited,
    this.url,
  });

  factory SpeciesModel.fromJson(Map<String, dynamic> json) => SpeciesModel(
    name: json['name'],
    classification: json['classification'],
    designation: json['designation'],
    averageHeight: json['average_height'],
    skinColors: json['skin_colors'],
    hairColors: json['hair_colors'],
    eyeColors: json['eye_colors'],
    averageLifespan: json['average_lifespan'],
    homeworld: json['homeworld'],
    language: json['language'],
    people: json['people'] == null
        ? []
        : List<String>.from(json['people']!.map((x) => x)),
    films: json['films'] == null
        ? []
        : List<String>.from(json['films']!.map((x) => x)),
    created: json['created'] == null ? null : DateTime.parse(json['created']),
    edited: json['edited'] == null ? null : DateTime.parse(json['edited']),
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'classification': classification,
    'designation': designation,
    'average_height': averageHeight,
    'skin_colors': skinColors,
    'hair_colors': hairColors,
    'eye_colors': eyeColors,
    'average_lifespan': averageLifespan,
    'homeworld': homeworld,
    'language': language,
    'people': people == null ? [] : List<dynamic>.from(people!.map((x) => x)),
    'films': films == null ? [] : List<dynamic>.from(films!.map((x) => x)),
    'created': created?.toIso8601String(),
    'edited': edited?.toIso8601String(),
    'url': url,
  };
}
