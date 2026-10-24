import '../entities/species/species_entity.dart';

abstract class SpeciesRepository {
  Future<SpeciesEntity> getSpeciesDetail(int id);
}
