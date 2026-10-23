import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/film/film_entity.dart';
import '../../../domain/usecase/get_film_detail_usecase.dart';
import '../../../domain/usecase/get_people_detail_usecase.dart';
import '../../../domain/usecase/get_planet_detail_usecase.dart';
import '../../../domain/usecase/get_species_detail_usecase.dart';
import '../../../domain/usecase/get_starship_detail_usecase.dart';
import '../../../domain/usecase/get_vehicle_detail_usecase.dart';
import '../views/widgets/entity_detail_bottom_sheet.dart';

class FilmDetailController extends GetxController {
  final GetFilmDetailUseCase _getFilmDetailUseCase;
  final GetPeopleDetailUseCase _getPeopleDetailUseCase;
  final GetPlanetDetailUseCase _getPlanetDetailUseCase;
  final GetSpeciesDetailUseCase _getSpeciesDetailUseCase;
  final GetStarshipDetailUseCase _getStarshipDetailUseCase;
  final GetVehicleDetailUseCase _getVehicleDetailUseCase;

  FilmDetailController({
    required GetFilmDetailUseCase getFilmDetailUseCase,
    required GetPeopleDetailUseCase getPeopleDetailUseCase,
    required GetPlanetDetailUseCase getPlanetDetailUseCase,
    required GetSpeciesDetailUseCase getSpeciesDetailUseCase,
    required GetStarshipDetailUseCase getStarshipDetailUseCase,
    required GetVehicleDetailUseCase getVehicleDetailUseCase,
  }) : _getFilmDetailUseCase = getFilmDetailUseCase,
       _getPeopleDetailUseCase = getPeopleDetailUseCase,
       _getPlanetDetailUseCase = getPlanetDetailUseCase,
       _getSpeciesDetailUseCase = getSpeciesDetailUseCase,
       _getStarshipDetailUseCase = getStarshipDetailUseCase,
       _getVehicleDetailUseCase = getVehicleDetailUseCase;

  final film = Rx<FilmEntity?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final selectedEntity = Rx<dynamic>(null);
  final isEntityLoading = false.obs;
  final entityError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is FilmEntity) {
      film.value = args;
    }

    final id = _resolveFilmId();
    if (id != null && film.value == null) {
      fetchDetail(id);
    }
  }

  int? _resolveFilmId() {
    if (film.value?.url != null) {
      final segments = film.value!.url!
          .split('/')
          .where((s) => s.isNotEmpty)
          .toList();
      if (segments.isNotEmpty) {
        return int.tryParse(segments.last);
      }
    }
    final paramId = Get.parameters['id'];
    if (paramId != null) {
      return int.tryParse(paramId);
    }
    return null;
  }

  Future<void> fetchDetail(int id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _getFilmDetailUseCase(id);
      film.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onEntityTap(
    BuildContext context, {
    required String type,
    required String url,
  }) {
    fetchEntityDetail(type: type, url: url);

    Get.bottomSheet(
      EntityDetailBottomSheet(controller: this, entityType: type, url: url),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> fetchEntityDetail({
    required String type,
    required String url,
  }) async {
    isEntityLoading.value = true;
    entityError.value = '';
    selectedEntity.value = null;

    final segments = url.split('/').where((s) => s.isNotEmpty).toList();
    final id = segments.isNotEmpty ? int.tryParse(segments.last) : null;

    if (id == null) {
      entityError.value = 'ID tidak valid dari URL: $url';
      isEntityLoading.value = false;
      return;
    }

    try {
      selectedEntity.value = switch (type.toLowerCase()) {
        'character' || 'people' => await _getPeopleDetailUseCase(id),
        'planet' => await _getPlanetDetailUseCase(id),
        'species' => await _getSpeciesDetailUseCase(id),
        'starship' => await _getStarshipDetailUseCase(id),
        'vehicle' => await _getVehicleDetailUseCase(id),
        _ => throw Exception('Tipe entitas "$type" tidak didukung.'),
      };
    } catch (e) {
      entityError.value = e.toString();
    } finally {
      isEntityLoading.value = false;
    }
  }
}
