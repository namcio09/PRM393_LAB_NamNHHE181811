import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_session.dart';

class SessionStorage {
  static const _sessionKey = 'lab10.session';

  Future<UserSession?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null) return null;
    try {
      return UserSession.fromJson(raw);
    } catch (_) {
      await prefs.remove(_sessionKey);
      return null;
    }
  }

  Future<void> write(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, session.toJson());
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
