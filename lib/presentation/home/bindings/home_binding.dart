import 'package:get/get.dart';

import '../../../data/datasource/films/film_data_source.dart';
import '../../../data/datasource/films/film_data_source_impl.dart';
import '../../../data/network/api_provider.dart';
import '../../../data/repository/film_repository_impl.dart';
import '../../../domain/repositories/film_repository.dart';
import '../../../domain/usecase/get_films_usecase.dart';
import '../../reminder/bindings/reminder_binding.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    ReminderBinding().dependencies();
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<FilmDataSource>(
      () => FilmDataSourceImpl(apiProvider: Get.find<ApiProvider>()),
    );
    Get.lazyPut<FilmRepository>(
      () => FilmRepositoryImpl(filmDataSource: Get.find<FilmDataSource>()),
    );
    Get.lazyPut<GetFilmsUseCase>(
      () => GetFilmsUseCase(Get.find<FilmRepository>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(getFilmsUseCase: Get.find<GetFilmsUseCase>()),
    );
  }
}
