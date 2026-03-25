class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final String genres;
  final double rating;
  final List<String> trailer;

  Movie({
    required this.id,
    required this.title,
    this.posterUrl = "",
    this.overview = "",
    required this.genres,
    this.rating = 0,
    required this.trailer,
  });
}
