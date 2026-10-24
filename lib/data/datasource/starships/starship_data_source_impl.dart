import '../../../app/utils/const/api/api_url.dart';
import '../../model/starship/starship_model.dart';
import '../../network/api_provider.dart';
import 'starship_data_source.dart';

class StarshipDataSourceImpl extends StarshipDataSource {
  final ApiProvider _apiProvider;

  StarshipDataSourceImpl({required ApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<StarshipModel> getStarshipDetail(int id) async {
    final response = await _apiProvider.call(
      ApiUrl.starshipDetail(id),
      method: MethodRequest.get,
    );

    return StarshipModel.fromJson(response);
  }
}
