import '../entities/starship/starship_entity.dart';

abstract class StarshipRepository {
  Future<StarshipEntity> getStarshipDetail(int id);
}
