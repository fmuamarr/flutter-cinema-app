import '../entities/film/film_entity.dart';
import '../repositories/film_repository.dart';

class GetFilmDetailUseCase {
  final FilmRepository _repository;

  GetFilmDetailUseCase(this._repository);

  Future<FilmEntity> call(int id) {
    return _repository.getFilmDetail(id);
  }
}
