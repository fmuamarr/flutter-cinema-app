import '../../domain/entities/people/people_entity.dart';
import '../model/people/people_model.dart';

extension PeopleModelMapper on PeopleModel {
  PeopleEntity toEntity() {
    return PeopleEntity(
      name: name,
      height: height,
      mass: mass,
      hairColor: hairColor,
      skinColor: skinColor,
      eyeColor: eyeColor,
      birthYear: birthYear,
      gender: gender,
      homeworld: homeworld,
      films: films,
      species: species,
      vehicles: vehicles,
      starships: starships,
      created: created,
      edited: edited,
      url: url,
    );
  }
}
