import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiService {
  ApiService({
    http.Client? client,
    this.baseUrl = 'https://jsonplaceholder.typicode.com',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _buildUri(String path) => Uri.parse('$baseUrl$path');

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _client.get(_buildUri('/posts'));
      if (response.statusCode != 200) {
        throw ApiException('Unable to load posts (code: ${response.statusCode})');
      }

      final List<dynamic> decoded = json.decode(response.body) as List<dynamic>;
      return decoded
          .map((dynamic item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (error) {
      if (error is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to connect to server. Please try again.');
    }
  }

  Future<Post> createPost({
    required String title,
    required String body,
  }) async {
    try {
      final response = await _client.post(
        _buildUri('/posts'),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: json.encode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      );

      if (response.statusCode != 201) {
        throw ApiException('Unable to create post (code: ${response.statusCode})');
      }

      final Map<String, dynamic> decoded =
          json.decode(response.body) as Map<String, dynamic>;
      return Post.fromJson(decoded);
    } catch (error) {
      if (error is ApiException) {
        rethrow;
      }
      throw ApiException('Failed to send data. Please try again.');
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
