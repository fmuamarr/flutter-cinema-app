import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/app/services/notification_service.dart';
import 'package:movies_app/domain/entities/film/film_entity.dart';
import 'package:movies_app/presentation/reminder/controllers/reminder_controller.dart';
import 'package:movies_app/presentation/reminder/models/movie_reminder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeNotificationService implements NotificationService {
  @override
  Future<void> init() async {}

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<bool> canScheduleExact() async => true;

  @override
  Future<void> requestExactAlarmPermission() async {}

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {}

  @override
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {}

  @override
  Future<void> cancelNotification(int id) async {}

  @override
  Future<void> cancelAll() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MovieReminder Model Tests', () {
    test('MovieReminder fromJson and toJson should roundtrip properly', () {
      final now = DateTime.now();
      final reminder = MovieReminder(
        id: 1,
        filmId: 1,
        filmTitle: 'A New Hope',
        showTime: now,
        reminderTime: now.subtract(const Duration(minutes: 15)),
        offsetMinutes: 15,
        note: 'CGV PVJ - Auditorium 1',
        posterPath: 'assets/images/poster/episode-4.jpg',
        createdAt: now,
      );

      final json = reminder.toJson();
      expect(json['id'], 1);
      expect(json['film_id'], 1);
      expect(json['film_title'], 'A New Hope');
      expect(json['offset_minutes'], 15);
      expect(json['note'], 'CGV PVJ - Auditorium 1');

      final fromJson = MovieReminder.fromJson(json);
      expect(fromJson.id, reminder.id);
      expect(fromJson.filmTitle, reminder.filmTitle);
      expect(fromJson.offsetMinutes, reminder.offsetMinutes);
      expect(fromJson.note, reminder.note);
      expect(fromJson.isPast, isTrue);
    });
  });

  group('ReminderController Tests', () {
    late ReminderController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      controller = ReminderController(
        notificationService: FakeNotificationService(),
      );
    });

    test('scheduleReminder should save reminder and update reactive list',
        () async {
      final film = FilmEntity(
        title: 'Return of the Jedi',
        episodeId: 6,
      );

      final showTime = DateTime.now().add(const Duration(days: 2));
      final reminderTime = showTime.subtract(const Duration(minutes: 30));

      final success = await controller.scheduleReminder(
        film: film,
        showTime: showTime,
        reminderTime: reminderTime,
        offsetMinutes: 30,
        note: 'Studio IMAX',
      );

      expect(success, isTrue);
      expect(controller.reminders.length, 1);
      expect(controller.currentFilmReminder.value?.filmTitle,
          'Return of the Jedi');
      expect(controller.currentFilmReminder.value?.note, 'Studio IMAX');

      // Cancel reminder
      await controller.cancelReminder(6, filmId: 6);
      expect(controller.reminders, isEmpty);
      expect(controller.currentFilmReminder.value, isNull);
    });
  });
}
