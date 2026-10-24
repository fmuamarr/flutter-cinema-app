import 'package:get/get.dart';

import '../../../data/datasource/films/film_data_source.dart';
import '../../../data/datasource/films/film_data_source_impl.dart';
import '../../../data/datasource/peoples/people_data_source.dart';
import '../../../data/datasource/peoples/people_data_source_impl.dart';
import '../../../data/datasource/planets/planet_data_source.dart';
import '../../../data/datasource/planets/planet_data_source_impl.dart';
import '../../../data/datasource/species/species_data_source.dart';
import '../../../data/datasource/species/species_data_source_impl.dart';
import '../../../data/datasource/starships/starship_data_source.dart';
import '../../../data/datasource/starships/starship_data_source_impl.dart';
import '../../../data/datasource/vehicles/vehicle_data_source.dart';
import '../../../data/datasource/vehicles/vehicle_data_source_impl.dart';
import '../../../data/network/api_provider.dart';
import '../../../data/repository/film_repository_impl.dart';
import '../../../data/repository/people_repository_impl.dart';
import '../../../data/repository/planet_repository_impl.dart';
import '../../../data/repository/species_repository_impl.dart';
import '../../../data/repository/starship_repository_impl.dart';
import '../../../data/repository/vehicle_repository_impl.dart';
import '../../../domain/repositories/film_repository.dart';
import '../../../domain/repositories/people_repository.dart';
import '../../../domain/repositories/planet_repository.dart';
import '../../../domain/repositories/species_repository.dart';
import '../../../domain/repositories/starship_repository.dart';
import '../../../domain/repositories/vehicle_repository.dart';
import '../../../domain/usecase/get_film_detail_usecase.dart';
import '../../../domain/usecase/get_people_detail_usecase.dart';
import '../../../domain/usecase/get_planet_detail_usecase.dart';
import '../../../domain/usecase/get_species_detail_usecase.dart';
import '../../../domain/usecase/get_starship_detail_usecase.dart';
import '../../../domain/usecase/get_vehicle_detail_usecase.dart';
import '../controllers/film_detail_controller.dart';

class FilmDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ApiProvider>()) {
      Get.lazyPut<ApiProvider>(() => ApiProvider());
    }

    // datasource
    if (!Get.isRegistered<FilmDataSource>()) {
      Get.lazyPut<FilmDataSource>(
        () => FilmDataSourceImpl(apiProvider: Get.find<ApiProvider>()),
      );
    }
    if (!Get.isRegistered<PeopleDataSource>()) {
      Get.lazyPut<PeopleDataSource>(
        () => PeopleDataSourceImpl(apiProvider: Get.find<ApiProvider>()),
      );
    }
    if (!Get.isRegistered<PlanetDataSource>()) {
      Get.lazyPut<PlanetDataSource>(
        () => PlanetDataSourceImpl(apiProvider: Get.find<ApiProvider>()),
      );
    }
    if (!Get.isRegistered<SpeciesDataSource>()) {
      Get.lazyPut<SpeciesDataSource>(
        () => SpeciesDataSourceImpl(apiProvider: Get.find<ApiProvider>()),
      );
    }
    if (!Get.isRegistered<StarshipDataSource>()) {
      Get.lazyPut<StarshipDataSource>(
        () => StarshipDataSourceImpl(apiProvider: Get.find<ApiProvider>()),
      );
    }
    if (!Get.isRegistered<VehicleDataSource>()) {
      Get.lazyPut<VehicleDataSource>(
        () => VehicleDataSourceImpl(apiProvider: Get.find<ApiProvider>()),
      );
    }

    // repo
    if (!Get.isRegistered<FilmRepository>()) {
      Get.lazyPut<FilmRepository>(
        () => FilmRepositoryImpl(filmDataSource: Get.find<FilmDataSource>()),
      );
    }
    if (!Get.isRegistered<PeopleRepository>()) {
      Get.lazyPut<PeopleRepository>(
        () => PeopleRepositoryImpl(
          peopleDataSource: Get.find<PeopleDataSource>(),
        ),
      );
    }
    if (!Get.isRegistered<PlanetRepository>()) {
      Get.lazyPut<PlanetRepository>(
        () => PlanetRepositoryImpl(
          planetDataSource: Get.find<PlanetDataSource>(),
        ),
      );
    }
    if (!Get.isRegistered<SpeciesRepository>()) {
      Get.lazyPut<SpeciesRepository>(
        () => SpeciesRepositoryImpl(
          speciesDataSource: Get.find<SpeciesDataSource>(),
        ),
      );
    }
    if (!Get.isRegistered<StarshipRepository>()) {
      Get.lazyPut<StarshipRepository>(
        () => StarshipRepositoryImpl(
          starshipDataSource: Get.find<StarshipDataSource>(),
        ),
      );
    }
    if (!Get.isRegistered<VehicleRepository>()) {
      Get.lazyPut<VehicleRepository>(
        () => VehicleRepositoryImpl(
          vehicleDataSource: Get.find<VehicleDataSource>(),
        ),
      );
    }

    // usecase
    Get.lazyPut<GetFilmDetailUseCase>(
      () => GetFilmDetailUseCase(Get.find<FilmRepository>()),
    );
    Get.lazyPut<GetPeopleDetailUseCase>(
      () => GetPeopleDetailUseCase(Get.find<PeopleRepository>()),
    );
    Get.lazyPut<GetPlanetDetailUseCase>(
      () => GetPlanetDetailUseCase(Get.find<PlanetRepository>()),
    );
    Get.lazyPut<GetSpeciesDetailUseCase>(
      () => GetSpeciesDetailUseCase(Get.find<SpeciesRepository>()),
    );
    Get.lazyPut<GetStarshipDetailUseCase>(
      () => GetStarshipDetailUseCase(Get.find<StarshipRepository>()),
    );
    Get.lazyPut<GetVehicleDetailUseCase>(
      () => GetVehicleDetailUseCase(Get.find<VehicleRepository>()),
    );

    // controller
    Get.lazyPut<FilmDetailController>(
      () => FilmDetailController(
        getFilmDetailUseCase: Get.find<GetFilmDetailUseCase>(),
        getPeopleDetailUseCase: Get.find<GetPeopleDetailUseCase>(),
        getPlanetDetailUseCase: Get.find<GetPlanetDetailUseCase>(),
        getSpeciesDetailUseCase: Get.find<GetSpeciesDetailUseCase>(),
        getStarshipDetailUseCase: Get.find<GetStarshipDetailUseCase>(),
        getVehicleDetailUseCase: Get.find<GetVehicleDetailUseCase>(),
      ),
    );
  }
}
