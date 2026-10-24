import '../../domain/entities/cinema/cinema_entity.dart';
import '../../domain/entities/cinema/cinema_route_entity.dart';
import '../../domain/repositories/cinema_repository.dart';
import '../datasource/cinema/cinema_local_data_source.dart';
import '../datasource/cinema/cinema_route_data_source.dart';
import '../mapper/cinema_mapper.dart';

class CinemaRepositoryImpl implements CinemaRepository {
  final CinemaLocalDataSource _localDataSource;
  final CinemaRouteDataSource _routeDataSource;

  CinemaRepositoryImpl({
    required CinemaLocalDataSource localDataSource,
    required CinemaRouteDataSource routeDataSource,
  }) : _localDataSource = localDataSource,
       _routeDataSource = routeDataSource;

  @override
  Future<List<CinemaEntity>> getCinemas() async {
    final models = await _localDataSource.getCinemas();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<CinemaRouteEntity> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    return _routeDataSource.getRoute(
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
    );
  }
}
