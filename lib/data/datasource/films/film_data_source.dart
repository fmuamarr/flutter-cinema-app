import '../../model/base_list_response.dart';
import '../../model/film/film_model.dart';

abstract class FilmDataSource {
  Future<BaseListResponse<List<FilmModel>>> getFilmsList();
  Future<FilmModel> getFilmDetail(int id);
}
