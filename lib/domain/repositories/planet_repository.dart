import '../entities/planet/planet_entity.dart';

abstract class PlanetRepository {
  Future<PlanetEntity> getPlanetDetail(int id);
}
