import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/infrastructure/routes/app_pages.dart';
import '../../../app/infrastructure/theme/theme.dart';
import '../../../app/utils/const/borderradius_const.dart';
import '../../../app/utils/film_poster_helper.dart';
import '../../../app/utils/utility/episode_to_roman.dart';
import '../../../domain/entities/film/film_entity.dart';
import '../../reminder/controllers/reminder_controller.dart';
import '../../reminder/models/movie_reminder.dart';
import '../../reminder/views/widgets/reminder_list_bottom_sheet.dart';
import '../../reminder/views/widgets/set_reminder_bottom_sheet.dart';
import '../controllers/film_detail_controller.dart';

class FilmDetailView extends GetView<FilmDetailController> {
  const FilmDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.disneyDeepBackground,
      appBar: AppBar(
        title: Text(
          'Film Details',
          style: context.textTheme.displaySmall?.copyWith(
            color: AppTheme.disneySilver,
            fontSize: 20,
          ),
        ),
        actions: [
          if (Get.isRegistered<ReminderController>())
            IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppTheme.disneyCyanAccent,
              ),
              tooltip: 'Daftar Reminder',
              onPressed: () {
                final reminderCtrl = Get.find<ReminderController>();
                Get.bottomSheet(
                  ReminderListBottomSheet(controller: reminderCtrl),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.film.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final id = controller.film.value?.episodeId;
                      if (id != null) controller.fetchDetail(id);
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final film = controller.film.value;
        if (film == null) {
          return const Center(child: Text('Data film tidak ditemukan.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackdropHeader(context, film),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetaSection(film),
                    const SizedBox(height: 16),
                    _buildActionButtons(context, film),
                    const SizedBox(height: 20),
                    _buildOpeningCrawl(context, film),
                    const SizedBox(height: 24),
                    Text(
                      'Film Entities',
                      style: context.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildEntityBlock(
                      context,
                      title: 'Characters',
                      urls: film.characters,
                      entityType: 'Character',
                    ),
                    _buildEntityBlock(
                      context,
                      title: 'Planets',
                      urls: film.planets,
                      entityType: 'Planet',
                    ),
                    _buildEntityBlock(
                      context,
                      title: 'Starships',
                      urls: film.starships,
                      entityType: 'Starship',
                    ),
                    _buildEntityBlock(
                      context,
                      title: 'Vehicles',
                      urls: film.vehicles,
                      entityType: 'Vehicle',
                    ),
                    _buildEntityBlock(
                      context,
                      title: 'Species',
                      urls: film.species,
                      entityType: 'Species',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBackdropHeader(BuildContext context, FilmEntity film) {
    final posterImg = FilmPosterHelper.getPoster(film.episodeId);
    final episodeRoman = toRoman(film.episodeId);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: posterImg != null
              ? Image.asset(
                  posterImg,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildFallbackPoster(context, episodeRoman),
                )
              : _buildFallbackPoster(context, episodeRoman),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppTheme.disneyDeepBackground.withValues(alpha: 0.6),
                  AppTheme.disneyDeepBackground,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              const SizedBox(height: 6),
              Text(
                film.title ?? 'Untitled',
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackPoster(BuildContext context, String episodeRoman) {
    return Container(
      color: AppTheme.disneyCardSurface,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.movie_creation_outlined,
            size: 48,
            color: AppTheme.disneyCyanAccent,
          ),
          const SizedBox(height: 8),
          Text(
            'STAR WARS: EPISODE $episodeRoman',
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

  Widget _buildMetaSection(FilmEntity film) {
    final releaseDateStr = film.releaseDate != null
        ? '${film.releaseDate!.year}-'
              '${film.releaseDate!.month.toString().padLeft(2, '0')}-'
              '${film.releaseDate!.day.toString().padLeft(2, '0')}'
        : '-';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.disneyCardSurface,
        borderRadius: BorderradiusConst.radiusAllSemiBig,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Director', film.director ?? '-'),
          const SizedBox(height: 6),
          _buildRow('Producer', film.producer ?? '-'),
          const SizedBox(height: 6),
          _buildRow('Release Date', releaseDateStr),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: Get.context?.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppTheme.disneySilver,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Get.context?.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOpeningCrawl(BuildContext context, FilmEntity film) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Crawl',
          style: context.textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.disneyCardSurface,
            borderRadius: BorderradiusConst.radiusAllSemiBig,
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Text(
            film.openingCrawl ?? '-',
            style: Get.context?.textTheme.bodySmall?.copyWith(
              color: AppTheme.yellowCrawl,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEntityBlock(
    BuildContext context, {
    required String title,
    required List<String>? urls,
    required String entityType,
  }) {
    if (urls == null || urls.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.disneyCardSurface,
        borderRadius: BorderradiusConst.radiusAllSemiBig,
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title (${urls.length})',
            style: Get.context?.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: urls.map((url) {
              final id = _extractId(url);
              final label = id.isNotEmpty ? '$entityType #$id' : url;

              return ActionChip(
                backgroundColor: AppTheme.disneyElevated,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                label: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.disneyCyanAccent,
                    fontSize: 12,
                  ),
                ),
                onPressed: () =>
                    controller.onEntityTap(context, type: entityType, url: url),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _extractId(String url) {
    final segments = url.split('/').where((s) => s.isNotEmpty).toList();
    return segments.isNotEmpty ? segments.last : '';
  }

  Widget _buildFindCinemaButton(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.disneyBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderradiusConst.radiusAllSmall,
        ),
      ),
      icon: const Icon(Icons.location_on_rounded, size: 18),
      label: Text(
        'Find Cinema',
        style: context.textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onPressed: () => Get.toNamed(Routes.CINEMA),
    );
  }

  Widget _buildActionButtons(BuildContext context, FilmEntity film) {
    if (!Get.isRegistered<ReminderController>()) {
      return SizedBox(
        width: double.infinity,
        child: _buildFindCinemaButton(context),
      );
    }

    final reminderCtrl = Get.find<ReminderController>();

    return Obx(() {
      final activeReminder = reminderCtrl.currentFilmReminder.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFindCinemaButton(context),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeReminder != null
                        ? AppTheme.disneyCardSurface
                        : AppTheme.disneyElevated,
                    foregroundColor: activeReminder != null
                        ? AppTheme.disneyCyanAccent
                        : Colors.white,
                    side: activeReminder != null
                        ? const BorderSide(
                            color: AppTheme.disneyCyanAccent,
                            width: 1.2,
                          )
                        : const BorderSide(color: Colors.white12),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderradiusConst.radiusAllSmall,
                    ),
                  ),
                  icon: Icon(
                    activeReminder != null
                        ? Icons.notifications_active_rounded
                        : Icons.alarm_add_rounded,
                    size: 18,
                    color: activeReminder != null
                        ? AppTheme.disneyCyanAccent
                        : Colors.white,
                  ),
                  label: Text(
                    activeReminder != null ? 'Reminder Set' : 'Set Reminder',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: activeReminder != null
                          ? AppTheme.disneyCyanAccent
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    Get.bottomSheet(
                      SetReminderBottomSheet(
                        film: film,
                        controller: reminderCtrl,
                        existingReminder: activeReminder,
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
              ),
            ],
          ),
          if (activeReminder != null) ...[
            const SizedBox(height: 10),
            _buildActiveReminderCard(
              context,
              film,
              activeReminder,
              reminderCtrl,
            ),
          ],
        ],
      );
    });
  }

  Widget _buildActiveReminderCard(
    BuildContext context,
    FilmEntity film,
    MovieReminder reminder,
    ReminderController reminderCtrl,
  ) {
    final day = reminder.showTime.day.toString().padLeft(2, '0');
    final month = reminder.showTime.month.toString().padLeft(2, '0');
    final year = reminder.showTime.year;
    final hour = reminder.showTime.hour.toString().padLeft(2, '0');
    final minute = reminder.showTime.minute.toString().padLeft(2, '0');
    final formattedTime = '$day/$month/$year $hour:$minute';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.disneyCardSurface,
        borderRadius: BorderradiusConst.radiusAllSmall,
        border: Border.all(
          color: AppTheme.disneyCyanAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.alarm_on_rounded,
            color: AppTheme.disneyCyanAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengingat Tayang Aktif',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AppTheme.disneyCyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tayang: $formattedTime',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_calendar_rounded,
              size: 18,
              color: AppTheme.disneySilver,
            ),
            tooltip: 'Ubah Jadwal',
            onPressed: () {
              Get.bottomSheet(
                SetReminderBottomSheet(
                  film: film,
                  controller: reminderCtrl,
                  existingReminder: reminder,
                ),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
          ),
        ],
      ),
    );
  }
}
