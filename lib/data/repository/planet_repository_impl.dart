import '../../domain/entities/planet/planet_entity.dart';
import '../../domain/repositories/planet_repository.dart';
import '../datasource/planets/planet_data_source.dart';
import '../mapper/planet_mapper.dart';

class PlanetRepositoryImpl implements PlanetRepository {
  final PlanetDataSource _planetDataSource;

  PlanetRepositoryImpl({required PlanetDataSource planetDataSource})
    : _planetDataSource = planetDataSource;

  @override
  Future<PlanetEntity> getPlanetDetail(int id) async {
    final response = await _planetDataSource.getPlanetDetail(id);
    return response.toEntity();
  }
}
