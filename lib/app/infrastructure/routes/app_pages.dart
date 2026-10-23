import 'package:get/get.dart';

import '../../../presentation/film_detail/bindings/film_detail_binding.dart';
import '../../../presentation/film_detail/views/film_detail_view.dart';
import '../../../presentation/home/bindings/home_binding.dart';
import '../../../presentation/home/views/home_view.dart';

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
  ];
}
