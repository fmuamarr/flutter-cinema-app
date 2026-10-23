import 'package:get/get.dart';

import '../../../data/datasource/films/film_data_source.dart';
import '../../../data/datasource/films/film_data_source_impl.dart';
import '../../../data/network/api_provider.dart';
import '../../../data/repository/film_repository_impl.dart';
import '../../../domain/repositories/film_repository.dart';
import '../../../domain/usecase/get_film_detail_usecase.dart';
import '../controllers/film_detail_controller.dart';

class FilmDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiProvider>()) {
      Get.lazyPut<ApiProvider>(() => ApiProvider());
    }
    if (!Get.isRegistered<FilmDataSource>()) {
      Get.lazyPut<FilmDataSource>(
        () => FilmDataSourceImpl(apiProvider: Get.find<ApiProvider>()),
      );
    }
    if (!Get.isRegistered<FilmRepository>()) {
      Get.lazyPut<FilmRepository>(
        () => FilmRepositoryImpl(filmDataSource: Get.find<FilmDataSource>()),
      );
    }
    Get.lazyPut<GetFilmDetailUseCase>(
      () => GetFilmDetailUseCase(Get.find<FilmRepository>()),
    );
    Get.lazyPut<FilmDetailController>(
      () => FilmDetailController(
        getFilmDetailUseCase: Get.find<GetFilmDetailUseCase>(),
      ),
    );
  }
}
