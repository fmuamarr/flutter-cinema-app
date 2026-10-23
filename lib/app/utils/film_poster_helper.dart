class FilmPosterHelper {
  static const Map<int, String> _posters = {
    1: 'assets/images/poster/episode-1.jpg',
    2: 'assets/images/poster/episode-2.jpg',
    3: 'assets/images/poster/episode-3.jpg',
    4: 'assets/images/poster/episode-4.jpg',
    5: 'assets/images/poster/episode-5.jpg',
    6: 'assets/images/poster/episode-6.jpg',
  };

  static String? getPoster(int? episodeId) {
    if (episodeId == null) return null;
    return _posters[episodeId];
  }
}
