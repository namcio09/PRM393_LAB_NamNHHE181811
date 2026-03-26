import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

class Movie {
  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });

  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;
}

const List<Movie> allMovies = [
  Movie(
    title: 'Starlight Guardians',
    year: 2024,
    genres: ['Action', 'Sci-Fi'],
    posterUrl:
        'https://images.unsplash.com/photo-1502139214982-d0ad755818d8?auto=format&fit=crop&w=600&q=80',
    rating: 8.7,
  ),
  Movie(
    title: 'Whispers of Autumn',
    year: 2021,
    genres: ['Drama', 'Romance'],
    posterUrl:
        'https://images.unsplash.com/photo-1508182311256-e3f9c5cf7a5e?auto=format&fit=crop&w=600&q=80',
    rating: 7.9,
  ),
  Movie(
    title: 'Laugh Lines',
    year: 2022,
    genres: ['Comedy'],
    posterUrl:
        'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?auto=format&fit=crop&w=600&q=80',
    rating: 7.4,
  ),
  Movie(
    title: 'Echoes in the Fog',
    year: 2020,
    genres: ['Thriller', 'Mystery'],
    posterUrl:
        'https://images.unsplash.com/photo-1478720568477-152d9b164e26?auto=format&fit=crop&w=600&q=80',
    rating: 8.2,
  ),
  Movie(
    title: 'Hidden Chef',
    year: 2019,
    genres: ['Family', 'Comedy'],
    posterUrl:
        'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=600&q=80',
    rating: 7.1,
  ),
  Movie(
    title: 'Northern Lights',
    year: 2023,
    genres: ['Adventure', 'Drama'],
    posterUrl:
        'https://images.unsplash.com/photo-1469474968028-56623f02e42e?auto=format&fit=crop&w=600&q=80',
    rating: 8.5,
  ),
];

final List<String> allGenres = {
  for (final movie in allMovies) ...movie.genres,
}.toList()
  ..sort();

enum SortOption { az, za, year, rating }

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.az:
        return 'A-Z';
      case SortOption.za:
        return 'Z-A';
      case SortOption.year:
        return 'Năm';
      case SortOption.rating:
        return 'Rating';
    }
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String _searchQuery = '';
  final Set<String> _selectedGenres = <String>{};
  SortOption _selectedSort = SortOption.az;

  List<Movie> get _visibleMovies {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = allMovies.where((movie) {
      final matchesQuery =
          query.isEmpty || movie.title.toLowerCase().contains(query);
      final matchesGenre = _selectedGenres.isEmpty ||
          movie.genres.any(_selectedGenres.contains);
      return matchesQuery && matchesGenre;
    }).toList();

    filtered.sort((a, b) {
      switch (_selectedSort) {
        case SortOption.az:
          return a.title.compareTo(b.title);
        case SortOption.za:
          return b.title.compareTo(a.title);
        case SortOption.year:
          return b.year.compareTo(a.year);
        case SortOption.rating:
          return b.rating.compareTo(a.rating);
      }
    });

    return filtered;
  }

  void _toggleGenre(String genre) {
    setState(() {
      if (_selectedGenres.contains(genre)) {
        _selectedGenres.remove(genre);
      } else {
        _selectedGenres.add(genre);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedGenres.clear();
      _selectedSort = SortOption.az;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movies = _visibleMovies;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find a Movie',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tìm kiếm, lọc theo thể loại và sắp xếp theo ý bạn.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              _buildSearchBar(theme),
              const SizedBox(height: 20),
              _buildGenreChips(theme),
              const SizedBox(height: 16),
              _buildSortAndActions(movies.length, theme),
              const SizedBox(height: 16),
              Expanded(child: _buildMovieList(movies)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'Nhập tên phim hoặc từ khóa...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildGenreChips(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thể loại',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final genre in allGenres)
              ChoiceChip(
                label: Text(genre),
                selected: _selectedGenres.contains(genre),
                onSelected: (_) => _toggleGenre(genre),
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: _selectedGenres.contains(genre)
                      ? theme.colorScheme.onPrimaryContainer
                      : null,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSortAndActions(int count, ThemeData theme) {
    final hasFilters = _searchQuery.isNotEmpty || _selectedGenres.isNotEmpty;

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$count phim phù hợp',
          style: theme.textTheme.labelLarge,
        ),
        DropdownButton<SortOption>(
          value: _selectedSort,
          items: [
            for (final option in SortOption.values)
              DropdownMenuItem(
                value: option,
                child: Text('Sắp xếp: ${option.label}'),
              ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedSort = value);
            }
          },
        ),
        if (hasFilters)
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear_all),
            label: const Text('Xóa bộ lọc'),
          ),
      ],
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy phim nào phù hợp.'),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;
        if (isWide) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.68,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) => MovieCard(movie: movies[index]),
          );
        }

        return ListView.separated(
          itemCount: movies.length,
          separatorBuilder: (context, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) => MovieCard(movie: movies[index]),
        );
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.movie, size: 48)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${movie.year} • ${movie.genres.join(', ')}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber.shade600, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
