import '../../entities/cinema/cinema_route_entity.dart';
import '../../repositories/cinema_repository.dart';

class GetCinemaRouteUseCase {
  final CinemaRepository _repository;

  GetCinemaRouteUseCase(this._repository);

  Future<CinemaRouteEntity> call({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) {
    return _repository.getRoute(
      originLat: originLat,
      originLng: originLng,
      destLat: destLat,
      destLng: destLng,
    );
  }
}
