import '../entities/base_list_entity.dart';
import '../entities/film/film_entity.dart';

abstract class FilmRepository {
  Future<BaseListEntity<List<FilmEntity?>>> getFilmsList();
  Future<FilmEntity> getFilmDetail(int id);
}
