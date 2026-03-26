import 'package:flutter/foundation.dart';

import '../core/app_exceptions.dart';
import '../models/user_session.dart';
import '../repositories/auth_repository.dart';
import '../services/local_notification_service.dart';

enum AuthStatus { checking, unauthenticated, authenticated }

class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository repository,
    required LocalNotificationService notificationService,
  })  : _repository = repository,
        _notificationService = notificationService;

  final AuthRepository _repository;
  final LocalNotificationService _notificationService;

  AuthStatus status = AuthStatus.checking;
  bool isBusy = false;
  bool googleAvailable = false;
  bool notificationsEnabled = false;
  String? errorMessage;
  UserSession? session;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  Future<void> bootstrap() async {
    status = AuthStatus.checking;
    errorMessage = null;
    notifyListeners();
    try {
      session = await _repository.loadSavedSession();
      status = session == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    } catch (error) {
      errorMessage = 'Failed to restore previous session';
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  void setGoogleAvailability(bool available) {
    googleAvailable = available;
    notifyListeners();
  }

  void setNotificationAvailability(bool enabled) {
    notificationsEnabled = enabled;
    notifyListeners();
  }

  Future<void> loginWithCredentials({
    required String username,
    required String password,
  }) async {
    await _execute(() => _repository.loginWithCredentials(
          username: username,
          password: password,
        ));
  }

  Future<void> loginWithGoogle() async {
    if (!googleAvailable) {
      errorMessage = 'Google Sign-In is not ready yet.';
      notifyListeners();
      return;
    }
    await _execute(_repository.loginWithGoogle);
  }

  Future<void> logout() async {
    isBusy = true;
    notifyListeners();
    try {
      await _repository.clearSession();
      session = null;
      status = AuthStatus.unauthenticated;
      errorMessage = null;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> replayNotification() async {
    final currentSession = session;
    if (!notificationsEnabled || currentSession == null) return;
    await _notificationService.showLoginSuccess(currentSession);
  }

  Future<void> _execute(Future<UserSession> Function() task) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();
    try {
      final newSession = await task();
      session = newSession;
      status = AuthStatus.authenticated;
      if (notificationsEnabled) {
        await _notificationService.showLoginSuccess(newSession);
      }
    } on AuthException catch (error) {
      errorMessage = error.message;
    } catch (error) {
      errorMessage = 'Something went wrong. Please try again.';
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
