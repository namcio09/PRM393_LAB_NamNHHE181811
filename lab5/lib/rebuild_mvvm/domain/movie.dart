class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final String genres;
  final double rating;
  final List<String> trailers;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });

  List<String> get genreList => genres.split(',').map((e) => e.trim()).toList();
}
