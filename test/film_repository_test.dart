import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/data/datasource/films/film_data_source.dart';
import 'package:movies_app/data/model/base_list_response.dart';
import 'package:movies_app/data/model/film/film_model.dart';
import 'package:movies_app/data/repository/film_repository_impl.dart';

// Fake datasource untuk simulasi response dari api swapi
class FakeFilmDataSource implements FilmDataSource {
  final BaseListResponse<List<FilmModel>>? mockListResponse;
  final FilmModel? mockDetailResponse;
  final Exception? error;

  FakeFilmDataSource({
    this.mockListResponse,
    this.mockDetailResponse,
    this.error,
  });

  @override
  Future<BaseListResponse<List<FilmModel>>> getFilmsList() async {
    if (error != null) throw error!;
    return mockListResponse!;
  }

  @override
  Future<FilmModel> getFilmDetail(int id) async {
    if (error != null) throw error!;
    return mockDetailResponse!;
  }
}

void main() {
  group('Film Repository - Data Fetching Tests', () {
    // 1) test fetch list film
    test(
      'getFilmsList() should fetch and return list of films from API',
      () async {
        // assert
        final fakeDataSource = FakeFilmDataSource(
          mockListResponse: BaseListResponse<List<FilmModel>>(
            count: 2,
            results: [
              FilmModel(
                title: 'A New Hope',
                episodeId: 4,
                director: 'George Lucas',
              ),
              FilmModel(
                title: 'The Empire Strikes Back',
                episodeId: 5,
                director: 'Irvin Kershner',
              ),
            ],
          ),
        );
        final repository = FilmRepositoryImpl(filmDataSource: fakeDataSource);

        // act
        final result = await repository.getFilmsList();

        // assert
        expect(result.count, 2);
        expect(result.results.length, 2);
        expect(result.results[0]?.title, 'A New Hope');
        expect(result.results[0]?.episodeId, 4);
        expect(result.results[1]?.title, 'The Empire Strikes Back');
      },
    );

    test(
      'getFilmsList() should throw exception when API request fails',
      () async {
        // arrange
        final fakeDataSource = FakeFilmDataSource(
          error: Exception('Failed to fetch film list from server'),
        );
        final repository = FilmRepositoryImpl(filmDataSource: fakeDataSource);

        // act & assert
        expect(() => repository.getFilmsList(), throwsA(isA<Exception>()));
      },
    );

    // 2) test fecthing data fil
    test(
      'getFilmDetail() should fetch and return single film detail by ID',
      () async {
        // Arrange
        final fakeDataSource = FakeFilmDataSource(
          mockDetailResponse: FilmModel(
            title: 'A New Hope',
            episodeId: 4,
            director: 'George Lucas',
            openingCrawl: 'It is a period of civil war...',
            characters: ['https://swapi.dev/api/people/1/'],
            planets: ['https://swapi.dev/api/planets/1/'],
          ),
        );
        final repository = FilmRepositoryImpl(filmDataSource: fakeDataSource);

        // act
        final result = await repository.getFilmDetail(4);

        // assert
        expect(result.title, 'A New Hope');
        expect(result.episodeId, 4);
        expect(result.director, 'George Lucas');
        expect(result.characters?.length, 1);
        expect(result.planets?.length, 1);
      },
    );

    test(
      'getFilmDetail() should throw exception when detail API fails',
      () async {
        // arrange
        final fakeDataSource = FakeFilmDataSource(
          error: Exception('Film with ID 99 not found'),
        );
        final repository = FilmRepositoryImpl(filmDataSource: fakeDataSource);

        expect(() => repository.getFilmDetail(99), throwsA(isA<Exception>()));
      },
    );
  });
}
