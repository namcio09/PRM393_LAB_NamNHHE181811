import 'package:lab5/rebuild_mvvm/config/sample_movie_data.dart';
import 'package:lab5/rebuild_mvvm/domain/movie.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_repository.g.dart';

abstract class MovieRepository {
  Future<List<Movie>> fetchMovies();
}

class SampleMovieRepository implements MovieRepository {
  @override
  Future<List<Movie>> fetchMovies() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return sampleMovies;
  }
}

@riverpod
MovieRepository movieRepository(MovieRepositoryRef ref) {
  return SampleMovieRepository();
}
