import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/services/notification_service.dart';
import '../../../app/utils/film_poster_helper.dart';
import '../../../domain/entities/film/film_entity.dart';
import '../models/movie_reminder.dart';

class ReminderController extends GetxController {
  static const String _storageKey = 'movie_reminders_storage';

  final NotificationService _notificationService;
  final SharedPreferences? _prefsOverride;

  ReminderController({
    NotificationService? notificationService,
    SharedPreferences? prefs,
  }) : _notificationService = notificationService ?? NotificationService(),
       _prefsOverride = prefs;

  final reminders = <MovieReminder>[].obs;
  final currentFilmReminder = Rx<MovieReminder?>(null);
  final isLoading = false.obs;
  final isSaving = false.obs;

  Future<SharedPreferences> get _prefs async =>
      _prefsOverride ?? await SharedPreferences.getInstance();

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  Future<void> loadReminders() async {
    isLoading.value = true;
    try {
      final prefs = await _prefs;
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        final list = decoded
            .map((item) => MovieReminder.fromJson(item as Map<String, dynamic>))
            .toList();
        list.sort((a, b) => a.reminderTime.compareTo(b.reminderTime));
        reminders.assignAll(list);
      } else {
        reminders.clear();
      }
    } catch (e) {
      debugPrint('Failed to load reminders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFilmReminder(int filmId) async {
    try {
      await loadReminders();
      currentFilmReminder.value = getReminderForFilm(filmId);
    } catch (e) {
      debugPrint('Failed to load film reminder: $e');
    }
  }

  MovieReminder? getReminderForFilm(int filmId) {
    try {
      return reminders.firstWhere((r) => r.filmId == filmId);
    } catch (_) {
      return null;
    }
  }

  Future<bool> scheduleReminder({
    required FilmEntity film,
    required DateTime showTime,
    required DateTime reminderTime,
    int offsetMinutes = 0,
    String? note,
  }) async {
    final episodeId = film.episodeId;
    if (episodeId == null) {
      _showSnackbar(
        'Failed',
        'Invalid Film ID.',
        backgroundColor: Colors.redAccent,
      );
      return false;
    }

    if (reminderTime.isBefore(DateTime.now())) {
      _showSnackbar(
        'Invalid Time',
        'Reminder time must be later than the current time.',
        backgroundColor: Colors.orangeAccent,
      );
      return false;
    }

    isSaving.value = true;
    try {
      final reminder = MovieReminder(
        id: episodeId,
        filmId: episodeId,
        filmTitle: film.title ?? 'Movie',
        showTime: showTime,
        reminderTime: reminderTime,
        offsetMinutes: offsetMinutes,
        note: note,
        posterPath: FilmPosterHelper.getPoster(episodeId),
        createdAt: DateTime.now(),
      );

      // Save to SharedPreferences
      final prefs = await _prefs;
      final currentList = List<MovieReminder>.from(reminders);
      final index = currentList.indexWhere((r) => r.filmId == episodeId);
      if (index != -1) {
        currentList[index] = reminder;
      } else {
        currentList.add(reminder);
      }
      currentList.sort((a, b) => a.reminderTime.compareTo(b.reminderTime));

      final encoded = jsonEncode(currentList.map((r) => r.toJson()).toList());
      await prefs.setString(_storageKey, encoded);

      // schedule notification
      await _notificationService.requestPermissions();
      final body = note != null && note.isNotEmpty
          ? note
          : 'Waktu nonton film ${film.title} sudah tiba!';

      await _notificationService.scheduleNotification(
        id: reminder.id,
        title: '🎬 Movie Reminder: ${film.title}',
        body: body,
        scheduledDate: reminder.reminderTime,
        payload: reminder.filmId.toString(),
      );

      reminders.assignAll(currentList);
      currentFilmReminder.value = reminder;

      _showSnackbar(
        'Reminder Set',
        'Reminder notification for "${film.title}" has been scheduled.',
        backgroundColor: const Color(0xFF107C41),
      );
      return true;
    } catch (e) {
      _showSnackbar(
        'Failed to Set',
        e.toString(),
        backgroundColor: Colors.redAccent,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> cancelReminder(int reminderId, {int? filmId}) async {
    try {
      final prefs = await _prefs;
      final currentList = List<MovieReminder>.from(reminders);
      currentList.removeWhere(
        (r) => r.id == reminderId || (filmId != null && r.filmId == filmId),
      );

      final encoded = jsonEncode(currentList.map((r) => r.toJson()).toList());
      await prefs.setString(_storageKey, encoded);

      // Cancel notification
      await _notificationService.cancelNotification(reminderId);

      reminders.assignAll(currentList);
      if (currentFilmReminder.value?.id == reminderId ||
          currentFilmReminder.value?.filmId == filmId) {
        currentFilmReminder.value = null;
      }

      _showSnackbar(
        'Reminder Delete',
        'Delete reminder successfully.',
        backgroundColor: const Color(0xFF333333),
      );
    } catch (e) {
      _showSnackbar(
        'Failed to Delete',
        e.toString(),
        backgroundColor: Colors.redAccent,
      );
    }
  }

  void _showSnackbar(
    String title,
    String message, {
    Color? backgroundColor,
    Color? colorText,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: backgroundColor ?? const Color(0xFF333333),
          colorText: colorText ?? Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );
      }
    });
  }
}
