import '../entities/cinema/cinema_entity.dart';
import '../entities/cinema/cinema_route_entity.dart';

abstract class CinemaRepository {
  Future<List<CinemaEntity>> getCinemas();

  Future<CinemaRouteEntity> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  });
}
