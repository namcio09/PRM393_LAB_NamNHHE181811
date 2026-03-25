import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_movies_view_model.g.dart';

@riverpod
class FavoriteMoviesViewModel extends _$FavoriteMoviesViewModel {
  @override
  Set<int> build() => <int>{};

  bool isFavorite(int movieId) => state.contains(movieId);

  void toggleFavorite(int movieId) {
    if (state.contains(movieId)) {
      state = {...state}..remove(movieId);
      return;
    }

    state = {...state, movieId};
  }
}
