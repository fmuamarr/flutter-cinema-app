import '../../../app/utils/const/api/api_url.dart';
import '../../model/base_list_response.dart';
import '../../model/film/film_model.dart';
import '../../network/api_provider.dart';
import 'film_data_source.dart';

class FilmDataSourceImpl extends FilmDataSource {
  final ApiProvider _apiProvider;

  FilmDataSourceImpl({required ApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<BaseListResponse<List<FilmModel>>> getFilmsList() async {
    final response = await _apiProvider.call(
      ApiUrl.filmList,
      method: MethodRequest.get,
    );

    return BaseListResponse.fromJson(
      response: response,
      onResult: (list) => list.map((e) => FilmModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<FilmModel> getFilmDetail(int id) async {
    final response = await _apiProvider.call(
      ApiUrl.filmDetail(id),
      method: MethodRequest.get,
    );

    return FilmModel.fromJson(response);
  }
}
