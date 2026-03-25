import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lab5/rebuild_mvvm/presentation/pages/movie_detail_page.dart';
import 'package:lab5/rebuild_mvvm/presentation/viewmodels/favorite_movies_view_model.dart';
import 'package:lab5/rebuild_mvvm/presentation/viewmodels/movie_list_view_model.dart';
import 'package:lab5/rebuild_mvvm/presentation/widgets/movie_card.dart';

class MovieListPage extends ConsumerWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieListState = ref.watch(movieListViewModelProvider);
    final favoriteIds = ref.watch(favoriteMoviesViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const Text('Movie App (MVVM)'),
        centerTitle: false,
      ),
      body: movieListState.when(
        data: (movies) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return MovieCard(
              movie: movie,
              isFavorite: favoriteIds.contains(movie.id),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailPage(movie: movie),
                  ),
                );
              },
            );
          },
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Can not load movies: $error'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
