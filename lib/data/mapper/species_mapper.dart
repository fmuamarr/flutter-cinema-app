import '../../domain/entities/species/species_entity.dart';
import '../model/species/species_model.dart';

extension SpeciesModelMapper on SpeciesModel {
  SpeciesEntity toEntity() {
    return SpeciesEntity(
      name: name,
      classification: classification,
      designation: designation,
      averageHeight: averageHeight,
      skinColors: skinColors,
      hairColors: hairColors,
      eyeColors: eyeColors,
      averageLifespan: averageLifespan,
      homeworld: homeworld,
      language: language,
      people: people,
      films: films,
      created: created,
      edited: edited,
      url: url,
    );
  }
}
