import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/film/film_entity.dart';
import '../../../domain/usecase/get_film_detail_usecase.dart';

class FilmDetailController extends GetxController {
  final GetFilmDetailUseCase _getFilmDetailUseCase;

  FilmDetailController({required GetFilmDetailUseCase getFilmDetailUseCase})
    : _getFilmDetailUseCase = getFilmDetailUseCase;

  final film = Rx<FilmEntity?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

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
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$type Detail', style: context.textTheme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Source URL:',
                style: TextStyle(
                  fontSize: 12,
                  color: Get.theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(url, style: context.textTheme.bodySmall),
              const SizedBox(height: 12),
              const Text('Todo', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
