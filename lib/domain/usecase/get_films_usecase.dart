import '../entities/base_list_entity.dart';
import '../entities/film/film_entity.dart';
import '../repositories/film_repository.dart';

class GetFilmsUseCase {
  final FilmRepository _repository;

  GetFilmsUseCase(this._repository);

  Future<BaseListEntity<List<FilmEntity?>>> call() {
    return _repository.getFilmsList();
  }
}
