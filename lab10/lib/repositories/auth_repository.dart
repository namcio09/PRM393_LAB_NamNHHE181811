import '../models/user_session.dart';
import '../services/dummy_json_auth_api.dart';
import '../services/firebase_google_auth_service.dart';
import '../services/session_storage.dart';

class AuthRepository {
  AuthRepository({
    required DummyJsonAuthApi api,
    required SessionStorage sessionStorage,
    required FirebaseGoogleAuthService firebaseService,
  })  : _api = api,
        _sessionStorage = sessionStorage,
        _firebaseService = firebaseService;

  final DummyJsonAuthApi _api;
  final SessionStorage _sessionStorage;
  final FirebaseGoogleAuthService _firebaseService;

  bool get isGoogleAvailable => _firebaseService.isAvailable;

  Future<bool> warmUpGoogle() => _firebaseService.initialize();

  Future<UserSession> loginWithCredentials(
      {required String username, required String password}) async {
    final session = await _api.authenticate(
      username: username,
      password: password,
    );
    await _sessionStorage.write(session);
    return session;
  }

  Future<UserSession> loginWithGoogle() async {
    final session = await _firebaseService.signIn();
    await _sessionStorage.write(session);
    return session;
  }

  Future<UserSession?> loadSavedSession() => _sessionStorage.read();

  Future<void> clearSession() async {
    await _firebaseService.signOut();
    await _sessionStorage.clear();
  }
}
