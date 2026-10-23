import '../../../app/utils/const/api/api_url.dart';
import '../../model/species/species_model.dart';
import '../../network/api_provider.dart';
import 'species_data_source.dart';

class SpeciesDataSourceImpl extends SpeciesDataSource {
  final ApiProvider _apiProvider;

  SpeciesDataSourceImpl({required ApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<SpeciesModel> getSpeciesDetail(int id) async {
    final response = await _apiProvider.call(
      ApiUrl.speciesDetail(id),
      method: MethodRequest.get,
    );

    return SpeciesModel.fromJson(response);
  }
}
