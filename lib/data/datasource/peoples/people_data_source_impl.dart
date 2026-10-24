import '../../../app/utils/const/api/api_url.dart';
import '../../model/people/people_model.dart';
import '../../network/api_provider.dart';
import 'people_data_source.dart';

class PeopleDataSourceImpl extends PeopleDataSource {
  final ApiProvider _apiProvider;

  PeopleDataSourceImpl({required ApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<PeopleModel> getPeopleDetail(int id) async {
    final response = await _apiProvider.call(
      ApiUrl.peopleDetail(id),
      method: MethodRequest.get,
    );

    return PeopleModel.fromJson(response);
  }
}
