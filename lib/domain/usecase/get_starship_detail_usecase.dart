import '../entities/starship/starship_entity.dart';
import '../repositories/starship_repository.dart';

class GetStarshipDetailUseCase {
  final StarshipRepository _repository;

  GetStarshipDetailUseCase(this._repository);

  Future<StarshipEntity> call(int id) {
    return _repository.getStarshipDetail(id);
  }
}
