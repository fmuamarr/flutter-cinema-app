import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/film/film_entity.dart';
import '../../../domain/usecase/get_films_usecase.dart';

class HomeController extends GetxController {
  final GetFilmsUseCase _getFilmsUseCase;

  HomeController({required GetFilmsUseCase getFilmsUseCase})
    : _getFilmsUseCase = getFilmsUseCase;

  final films = <FilmEntity>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getFilms();
  }

  Future<void> getFilms() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _getFilmsUseCase();
      final validList = response.results.whereType<FilmEntity>().toList();
      films.assignAll(validList);
    } catch (e) {
      debugPrint('Error getFilms: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
