import '../../model/planet/planet_model.dart';

abstract class PlanetDataSource {
  Future<PlanetModel> getPlanetDetail(int id);
}
