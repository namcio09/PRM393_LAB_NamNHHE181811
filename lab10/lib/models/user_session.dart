import 'dart:convert';

enum AuthProvider { dummyJson, google }

extension AuthProviderLabel on AuthProvider {
  String get label => switch (this) {
        AuthProvider.dummyJson => 'DummyJSON',
        AuthProvider.google => 'Google Account',
      };
}

AuthProvider authProviderFromStorage(String? value) {
  return AuthProvider.values.firstWhere(
    (provider) => provider.name == value,
    orElse: () => AuthProvider.dummyJson,
  );
}

class UserSession {
  const UserSession({
    required this.displayName,
    required this.token,
    required this.provider,
    this.id,
    this.email,
    this.avatarUrl,
  });

  final int? id;
  final String displayName;
  final String token;
  final String? email;
  final String? avatarUrl;
  final AuthProvider provider;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'token': token,
      'email': email,
      'avatarUrl': avatarUrl,
      'provider': provider.name,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory UserSession.fromMap(Map<String, dynamic> map) {
    return UserSession(
      id: map['id'] as int?,
      displayName: map['displayName'] as String,
      token: map['token'] as String,
      email: map['email'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      provider: authProviderFromStorage(map['provider'] as String?),
    );
  }

  factory UserSession.fromJson(String source) {
    final decoded = jsonDecode(source) as Map<String, dynamic>;
    return UserSession.fromMap(decoded);
  }
}
