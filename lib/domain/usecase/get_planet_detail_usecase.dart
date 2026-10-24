import '../entities/planet/planet_entity.dart';
import '../repositories/planet_repository.dart';

class GetPlanetDetailUseCase {
  final PlanetRepository _repository;

  GetPlanetDetailUseCase(this._repository);

  Future<PlanetEntity> call(int id) {
    return _repository.getPlanetDetail(id);
  }
}
