import 'package:get/get.dart';

import '../../../presentation/cinema/bindings/cinema_binding.dart';
import '../../../presentation/cinema/views/cinema_view.dart';
import '../../../presentation/film_detail/bindings/film_detail_binding.dart';
import '../../../presentation/film_detail/views/film_detail_view.dart';
import '../../../presentation/home/bindings/home_binding.dart';
import '../../../presentation/home/views/home_view.dart';
import '../../../presentation/reminder/bindings/reminder_binding.dart';
import '../../../presentation/reminder/views/reminder_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FILM_DETAIL,
      page: () => const FilmDetailView(),
      binding: FilmDetailBinding(),
    ),
    GetPage(
      name: _Paths.CINEMA,
      page: () => const CinemaView(),
      binding: CinemaBinding(),
    ),
    GetPage(
      name: _Paths.REMINDER,
      page: () => const ReminderView(),
      binding: ReminderBinding(),
    ),
  ];
}
