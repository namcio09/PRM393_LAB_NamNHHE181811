import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lab5/rebuild_mvvm/presentation/pages/movie_list_page.dart';

void main() {
  runApp(const ProviderScope(child: MovieAppMvvm()));
}

class MovieAppMvvm extends StatelessWidget {
  const MovieAppMvvm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App MVVM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MovieListPage(),
    );
  }
}
