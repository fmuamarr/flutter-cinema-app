import '../../domain/entities/starship/starship_entity.dart';
import '../model/starship/starship_model.dart';

extension StarshipModelMapper on StarshipModel {
  StarshipEntity toEntity() {
    return StarshipEntity(
      name: name,
      model: model,
      manufacturer: manufacturer,
      costInCredits: costInCredits,
      length: length,
      maxAtmospheringSpeed: maxAtmospheringSpeed,
      crew: crew,
      passengers: passengers,
      cargoCapacity: cargoCapacity,
      consumables: consumables,
      hyperdriveRating: hyperdriveRating,
      mglt: mglt,
      starshipClass: starshipClass,
      pilots: pilots,
      films: films,
      created: created,
      edited: edited,
      url: url,
    );
  }
}
