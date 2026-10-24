import '../../domain/entities/starship/starship_entity.dart';
import '../../domain/repositories/starship_repository.dart';
import '../datasource/starships/starship_data_source.dart';
import '../mapper/starship_mapper.dart';

class StarshipRepositoryImpl implements StarshipRepository {
  final StarshipDataSource _starshipDataSource;

  StarshipRepositoryImpl({required StarshipDataSource starshipDataSource})
    : _starshipDataSource = starshipDataSource;

  @override
  Future<StarshipEntity> getStarshipDetail(int id) async {
    final response = await _starshipDataSource.getStarshipDetail(id);
    return response.toEntity();
  }
}
