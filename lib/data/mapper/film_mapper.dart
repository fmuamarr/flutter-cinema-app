import '../../domain/entities/base_list_entity.dart';
import '../../domain/entities/film/film_entity.dart';
import '../model/base_list_response.dart';
import '../model/film/film_model.dart';

extension FilmsModelMapper on FilmModel {
  FilmEntity toEntity() {
    return FilmEntity(
      title: title,
      episodeId: episodeId,
      openingCrawl: openingCrawl,
      director: director,
      producer: producer,
      releaseDate: releaseDate,
      characters: characters,
      planets: planets,
      starships: starships,
      vehicles: vehicles,
      species: species,
      created: created,
      edited: edited,
      url: url,
    );
  }
}

extension BaseListResponseFilmMapper on BaseListResponse<List<FilmModel>> {
  BaseListEntity<List<FilmEntity?>> toEntity() {
    return BaseListEntity<List<FilmEntity?>>(
      count: count,
      next: next,
      previous: previous,
      results: results.map((item) => item.toEntity()).toList(),
    );
  }
}
