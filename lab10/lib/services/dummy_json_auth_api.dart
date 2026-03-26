import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/app_exceptions.dart';
import '../models/user_session.dart';

class DummyJsonAuthApi {
  DummyJsonAuthApi({http.Client? client}) : _client = client ?? http.Client();

  static const _endpoint = 'https://dummyjson.com/auth/login';
  final http.Client _client;

  Future<UserSession> authenticate({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username.trim(),
          'password': password,
          'expiresInMins': 60,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token']?.toString();
        if (token == null || token.isEmpty) {
          throw AuthException('Token missing from API response');
        }
        return UserSession(
          id: data['id'] as int?,
          displayName:
              '${data['firstName'] ?? data['username'] ?? 'User'} ${data['lastName'] ?? ''}'.trim(),
          token: token,
          email: data['email'] as String?,
          avatarUrl: data['image'] as String?,
          provider: AuthProvider.dummyJson,
        );
      }

      final error = jsonDecode(response.body);
      final message = error is Map<String, dynamic>
          ? error['message']?.toString()
          : null;
      throw AuthException(
        message ?? 'Unable to login. Please verify your credentials.',
      );
    } catch (error) {
      if (error is AuthException) rethrow;
      throw AuthException(
        'Could not reach DummyJSON. Check your internet connection.',
        cause: error,
      );
    }
  }
}
