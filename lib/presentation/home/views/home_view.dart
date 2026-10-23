import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/infrastructure/routes/app_pages.dart';
import '../../../app/infrastructure/theme/theme.dart';
import '../../../app/utils/const/borderradius_const.dart';
import '../../../app/utils/const/string_const.dart';
import '../../../app/utils/film_poster_helper.dart';
import '../../../app/utils/utility/episode_to_roman.dart';
import '../../../domain/entities/film/film_entity.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.disneyDeepBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.disneyDeepBackground,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringConst.appName,
              style: context.textTheme.displaySmall?.copyWith(
                color: AppTheme.disneySilver,
                fontSize: 20,
              ),
            ),
            Text(
              'Star Wars Movie Series',
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppTheme.disneyCyanAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.1,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: controller.getFilms,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.disneyCyanAccent),
          );
        }
        //Error handling
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.getFilms,
                    child: Text(
                      'Try Again',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.films.isEmpty) {
          return const Center(
            child: Text(
              'No films found.',
              style: TextStyle(color: AppTheme.disneySilver),
            ),
          );
        }

        return RefreshIndicator(
          color: AppTheme.disneyCyanAccent,
          backgroundColor: AppTheme.disneyCardSurface,
          onRefresh: controller.getFilms,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.films.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final film = controller.films[index];
              return _buildFilmCard(context, film);
            },
          ),
        );
      }),
    );
  }

  Widget _buildFilmCard(BuildContext context, FilmEntity film) {
    final episodeRoman = toRoman(film.episodeId);
    final posterImg = FilmPosterHelper.getPoster(film.episodeId);
    final releaseYear = film.releaseDate != null
        ? film.releaseDate!.year.toString()
        : '-';

    return InkWell(
      onTap: () => Get.toNamed(Routes.FILM_DETAIL, arguments: film),
      borderRadius: BorderradiusConst.radiusAllSemiBig,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.disneyCardSurface,
          borderRadius: BorderradiusConst.radiusAllSemiBig,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: posterImg != null
                        ? Image.asset(
                            posterImg,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildFallbackThumbnail(episodeRoman, context),
                          )
                        : _buildFallbackThumbnail(episodeRoman, context),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppTheme.disneyCardSurface.withValues(alpha: 0.8),
                            AppTheme.disneyCardSurface,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.disneyBlue,
                        borderRadius: BorderradiusConst.radiusAllVerySmall,
                      ),
                      child: Text(
                        'EPISODE $episodeRoman',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          film.title ?? 'Untitled',
                          style: context.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        releaseYear,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: AppTheme.disneySilver,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Director: ${film.director ?? '-'}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppTheme.disneySilver,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildEntityBadge(
                        context,
                        icon: Icons.people_outline,
                        label: '${film.characters?.length ?? 0} Characters',
                      ),
                      _buildEntityBadge(
                        context,
                        icon: Icons.public,
                        label: '${film.planets?.length ?? 0} Planets',
                      ),
                      _buildEntityBadge(
                        context,
                        icon: Icons.rocket_outlined,
                        label: '${film.starships?.length ?? 0} Starships',
                      ),
                      _buildEntityBadge(
                        context,
                        icon: Icons.groups_outlined,
                        label: '${film.species?.length ?? 0} Species',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackThumbnail(String episodeRoman, BuildContext context) {
    return Container(
      color: AppTheme.disneyElevated,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.movie_outlined,
            color: AppTheme.disneyCyanAccent,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'EPISODE $episodeRoman',
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntityBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.disneyElevated,
        borderRadius: BorderradiusConst.radiusAllExtraSmall,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.disneyCyanAccent),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: AppTheme.disneySilver,
            ),
          ),
        ],
      ),
    );
  }
}
