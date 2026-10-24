import '../../../app/utils/const/api/api_url.dart';
import '../../model/planet/planet_model.dart';
import '../../network/api_provider.dart';
import 'planet_data_source.dart';

class PlanetDataSourceImpl extends PlanetDataSource {
  final ApiProvider _apiProvider;

  PlanetDataSourceImpl({required ApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<PlanetModel> getPlanetDetail(int id) async {
    final response = await _apiProvider.call(
      ApiUrl.planetDetail(id),
      method: MethodRequest.get,
    );

    return PlanetModel.fromJson(response);
  }
}
