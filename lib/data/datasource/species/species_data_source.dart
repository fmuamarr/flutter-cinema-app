import '../../model/species/species_model.dart';

abstract class SpeciesDataSource {
  Future<SpeciesModel> getSpeciesDetail(int id);
}
