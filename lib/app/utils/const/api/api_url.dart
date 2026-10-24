class ApiUrl {
  static const String filmList = '/api/films/';
  static String filmDetail(int id) => '/api/films/$id/';
  static String peopleDetail(int id) => '/api/people/$id/';
  static String planetDetail(int id) => '/api/planets/$id/';
  static String speciesDetail(int id) => '/api/species/$id/';
  static String vehicleDetail(int id) => '/api/vehicles/$id/';
  static String starshipDetail(int id) => '/api/starships/$id/';
}
