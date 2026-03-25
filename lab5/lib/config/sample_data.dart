import 'package:lab5/entity/Movie.dart';

final List<Movie> sampleMovies = [
  Movie(
    id: 1,
    title: 'Interstellar',
    posterUrl: 'assets/images/poster1.jpg',
    overview:
        'A team of explorers travels through a wormhole in space to find a new home for humanity before Earth becomes uninhabitable.',
    genres: 'Sci-Fi, Adventure, Drama',
    rating: 8.6,
    trailer: [
      'assets/images/trailer-1a.jpg',
      'assets/images/trailer-1b.jpg',
      'assets/images/trailer-1c.jpg',
    ],
  ),
  Movie(
    id: 2,
    title: 'Inception',
    posterUrl: 'assets/images/poster2.jpg',
    overview:
        'A skilled thief enters people\'s dreams to steal secrets and is offered a chance at redemption by planting an idea instead.',
    genres: 'Action, Sci-Fi, Thriller',
    rating: 8.8,
    trailer: [
      'assets/images/trailer-2a.jpg',
      'assets/images/trailer2-b.jpg',
      'assets/images/trailer-2c.jpg',
    ],
  ),
  Movie(
    id: 3,
    title: 'The Dark Knight',
    posterUrl: 'assets/images/poster3.jpg',
    overview:
        'Batman faces the Joker, a criminal mastermind who pushes Gotham City into chaos and tests the limits of heroism.',
    genres: 'Action, Crime, Drama',
    rating: 9.0,
    trailer: [
      'assets/images/trailer-3a.jpg',
      'assets/images/trailer-3b.jpg',
      'assets/images/trailer-3c.jpg',
    ],
  ),
];
