import '../../domain/entities/planet/planet_entity.dart';
import '../model/planet/planet_model.dart';

extension PlanetModelMapper on PlanetModel {
  PlanetEntity toEntity() {
    return PlanetEntity(
      name: name,
      rotationPeriod: rotationPeriod,
      orbitalPeriod: orbitalPeriod,
      diameter: diameter,
      climate: climate,
      gravity: gravity,
      terrain: terrain,
      surfaceWater: surfaceWater,
      population: population,
      residents: residents,
      films: films,
      created: created,
      edited: edited,
      url: url,
    );
  }
}
