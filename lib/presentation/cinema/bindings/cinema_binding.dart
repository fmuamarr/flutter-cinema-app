import 'package:get/get.dart';

import '../../../data/datasource/cinema/cinema_local_data_source.dart';
import '../../../data/datasource/cinema/cinema_route_data_source.dart';
import '../../../data/repository/cinema_repository_impl.dart';
import '../../../domain/repositories/cinema_repository.dart';
import '../../../domain/usecase/cinema/get_cinema_route_usecase.dart';
import '../../../domain/usecase/cinema/get_cinemas_usecase.dart';
import '../controllers/cinema_controller.dart';

class CinemaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CinemaLocalDataSource>(() => CinemaLocalDataSourceImpl());
    Get.lazyPut<CinemaRouteDataSource>(() => CinemaRouteDataSourceImpl());
    Get.lazyPut<CinemaRepository>(
      () => CinemaRepositoryImpl(
        localDataSource: Get.find<CinemaLocalDataSource>(),
        routeDataSource: Get.find<CinemaRouteDataSource>(),
      ),
    );
    Get.lazyPut<GetCinemasUseCase>(
      () => GetCinemasUseCase(Get.find<CinemaRepository>()),
    );
    Get.lazyPut<GetCinemaRouteUseCase>(
      () => GetCinemaRouteUseCase(Get.find<CinemaRepository>()),
    );
    Get.lazyPut<CinemaController>(
      () => CinemaController(
        getCinemasUseCase: Get.find<GetCinemasUseCase>(),
        getCinemaRouteUseCase: Get.find<GetCinemaRouteUseCase>(),
      ),
    );
  }
}
