import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lab5/rebuild_mvvm/data/movie_repository.dart';
import 'package:lab5/rebuild_mvvm/domain/movie.dart';

part 'movie_list_view_model.g.dart';

@riverpod
class MovieListViewModel extends _$MovieListViewModel {
  @override
  Future<List<Movie>> build() async {
    final repository = ref.watch(movieRepositoryProvider);
    return repository.fetchMovies();
  }
}
