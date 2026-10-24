import '../entities/species/species_entity.dart';
import '../repositories/species_repository.dart';

class GetSpeciesDetailUseCase {
  final SpeciesRepository _repository;

  GetSpeciesDetailUseCase(this._repository);

  Future<SpeciesEntity> call(int id) {
    return _repository.getSpeciesDetail(id);
  }
}
