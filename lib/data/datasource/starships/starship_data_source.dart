import '../../model/starship/starship_model.dart';

abstract class StarshipDataSource {
  Future<StarshipModel> getStarshipDetail(int id);
}
