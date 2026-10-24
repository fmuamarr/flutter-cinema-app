import '../../domain/entities/species/species_entity.dart';
import '../../domain/repositories/species_repository.dart';
import '../datasource/species/species_data_source.dart';
import '../mapper/species_mapper.dart';

class SpeciesRepositoryImpl implements SpeciesRepository {
  final SpeciesDataSource _speciesDataSource;

  SpeciesRepositoryImpl({required SpeciesDataSource speciesDataSource})
    : _speciesDataSource = speciesDataSource;

  @override
  Future<SpeciesEntity> getSpeciesDetail(int id) async {
    final response = await _speciesDataSource.getSpeciesDetail(id);
    return response.toEntity();
  }
}
