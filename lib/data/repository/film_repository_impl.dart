import '../../domain/entities/base_list_entity.dart';
import '../../domain/entities/film/film_entity.dart';
import '../../domain/repositories/film_repository.dart';
import '../datasource/films/film_data_source.dart';
import '../mapper/film_mapper.dart';

class FilmRepositoryImpl implements FilmRepository {
  final FilmDataSource _filmDataSource;

  FilmRepositoryImpl({required FilmDataSource filmDataSource})
    : _filmDataSource = filmDataSource;

  @override
  Future<BaseListEntity<List<FilmEntity?>>> getFilmsList() async {
    final response = await _filmDataSource.getFilmsList();
    return response.toEntity();
  }

  @override
  Future<FilmEntity> getFilmDetail(int id) async {
    final response = await _filmDataSource.getFilmDetail(id);
    return response.toEntity();
  }
}

